//
//  SettingViewModel.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/07.
//

import Foundation

import RxCocoa
import RxSwift
import UPsKit

final class SettingViewModel: BaseViewModel {
  
  struct Input {
    let copyDidTap = PublishRelay<Void>()
    let shareDidTap = PublishRelay<Void>()
    let shareCancelDidTap = PublishRelay<Void>()
    let selectDay = PublishRelay<DateManager.Day>()
    let baseHour = BehaviorRelay<Int?>(value: nil)
    let weekPayDidTap = PublishRelay<Void>()
    let inputType = BehaviorRelay<Int?>(value: nil)
    let saveDidTap = PublishRelay<Void>()
  }
  
  struct Output {
    let selectDays = BehaviorRelay<[DateManager.Day]>(value: AppManager.shared.settingData?.days ?? [])
    let allDays = BehaviorRelay<[DateManager.Day]>(value: DateManager.Day.allCases)
    let baseHour = BehaviorRelay<String?>(value: nil)
    let inputType = BehaviorRelay<Int?>(value: nil)
  }
  
  
  
  // MARK: - Property
  
  let input = Input()
  let output = Output()
  
  private let shareAlert = PublishRelay<Void>()
  private let shareID = PublishRelay<String?>()
  private var settingData = AppManager.shared.settingData ?? SettingModel()
  
  
  
  // MARK: - Interface
  
  init() {
    super.init()
    
    self.input.copyDidTap
      .map { _ -> Bool in
        let deviceCount = AppManager.shared.settingData?.deviceList.count ?? 0
        return deviceCount < AppManager.shared.maxDeviceCount
      }
      .bind { [weak self] state in
        switch state {
        case true:
          UIPasteboard.general.string = UserDefaultsManager.firebaseID
          SceneCoordinator.shared.toast("공유 아이디가 복사 되었습니다")
          
        case false:
          self?.coordinator.toast("최대 3대 연결 가능합니다")
        }
      }
      .disposed(by: self.disposeBag)
    
    self.input.shareDidTap
      .map { _ -> Bool in
        let deviceCount = AppManager.shared.settingData?.deviceList.count ?? 0
        return deviceCount < AppManager.shared.maxDeviceCount
      }
      .bind { [weak self] state in
        switch state {
        case true:
          let actions: [UPsAlertActionProtocol] = [
            UPsAlertAction(
              title: "공유하기",
              handler: { _ in
                self?.shareAlert.accept(())
              }
            ),
            UPsAlertCancelAction()
          ]
          
          self?.coordinator.alert(
            title: "주 의",
            message: "공유하게되면 현재 아이디로 되어 있는 기록은 모두 삭제됩니다",
            actions: actions
          )
          
        case false:
          self?.coordinator.toast("최대 3대 연결 가능합니다")
        }
      }
      .disposed(by: self.disposeBag)
    
    self.shareAlert
      .bind { [weak self] in
        self?.coordinator.alertTextField(
          title: "공유하기",
          message: "공유 아이디를 입력해 주세요",
          actionTitle: "공유하기",
          cancel: "닫기",
          handler: { shareID in
            let currentID = UserDefaultsManager.firebaseID
            guard currentID != shareID else {
              self?.coordinator.toast("공유할 아이디를 입력해 주세요")
              return
            }
            
            self?.shareID.accept(shareID)
          }
        )
      }
      .disposed(by: self.disposeBag)
    
    self.shareID
      .compactMap { $0 }
      .filter { !$0.isEmpty }
      .bind { [weak self] id in
        guard let self = self else { return }
        let inType = UpdateType.share(id)
        let viewModel = UpdateViewModel(inType)
        let scene = Scene.update(viewModel)
        self.coordinator.transition(scene: scene, style: .root)
      }
      .disposed(by: self.disposeBag)
    
    self.input.shareCancelDidTap
      .map { _ -> Bool in
        let deviceCount = AppManager.shared.settingData?.deviceList.count ?? 0
        return deviceCount > 1
      }
      .bind { [weak self] state in
        switch state {
        case true:
          let inType = UpdateType.shareCancel
          let viewModel = UpdateViewModel(inType)
          let scene = Scene.update(viewModel)
          self?.coordinator.transition(scene: scene, style: .root)
          
        case false:
          self?.coordinator.toast("최소 1개는 연결되어 있어야 합니다")
        }
      }
      .disposed(by: self.disposeBag)
    
    
    self.input.selectDay
      .withLatestFrom(self.output.selectDays) { item, days in
        var tempDays = days
        
        if let index = tempDays.firstIndex(of: item) {
          tempDays.remove(at: index)
          
        } else {
          tempDays.append(item)
        }
        
        return tempDays.sorted { $0.weekdayInt < $1.weekdayInt }
      }
      .bind(to: self.output.selectDays)
      .disposed(by: self.disposeBag)
    
    self.output.selectDays
      .bind { [weak self] days in
        self?.settingData.days = days
      }
      .disposed(by: self.disposeBag)
    
    self.input.baseHour
      .compactMap { $0 }
      .bind { [weak self] hour in
        self?.settingData.workBaseHour = hour
        
        let text = String(hour) + "시간"
        self?.output.baseHour.accept(text)
      }
      .disposed(by: self.disposeBag)
    
    self.input.weekPayDidTap
      .bind {
        self.coordinator.alertTextField(
          title: "행복 계산기",
          message: "시급을 입력하시면 주간 급여를 계산합니다",
          keyboardType: .numberPad,
          actionTitle: "입력",
          cancel: "닫기",
          handler: { hourWage in
            guard let hourWage = hourWage, let hourWageInt = Int(hourWage) else { return }
            
            switch hourWageInt == 0 {
            case true:
              UserDefaultsManager.hourWage = nil
              
            case false:
              UserDefaultsManager.hourWage = hourWageInt
            }
          }
        )
      }
      .disposed(by: self.disposeBag)
    
    self.input.inputType
      .compactMap { $0 }
      .bind { [weak self] in
        self?.settingData.inputType = $0
      }
      .disposed(by: self.disposeBag)
    
    self.input.saveDidTap
      .bind { [weak self] in
        guard let self = self else { return }
        let inType = UpdateType.setting(self.settingData)
        let viewModel = UpdateViewModel(inType)
        let scene = Scene.update(viewModel)
        self.coordinator.transition(scene: scene, style: .root)
      }
      .disposed(by: self.disposeBag)
  }
}
