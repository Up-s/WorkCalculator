//
//  MainViewModel.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/05.
//

import Foundation

import RxCocoa
import RxSwift
import UPsKit

final class MainViewModel: BaseViewModel {
  
  struct Input {
    let refreshDidTap = PublishRelay<Void>()
    let historyDidTap = PublishRelay<Void>()
    let settingDidTap = PublishRelay<Void>()
  }
  
  struct Output {
    let blockViewModels = BehaviorRelay<[MainBlockViewModel]>(value: [])
    let sumRunTime = BehaviorRelay<Int>(value: 0)
  }
  
  // MARK: - Property
  
  let input = Input()
  let output = Output()
  
  var mainView: MainViewProtocol {
    switch UserDefaultsManager.mainType {
    case .week:
      return MainWeekView()
      
    case .day:
      return MainWeekView()
    }
  }
  
  
  
  // MARK: - Interface
  
  init() {
    super.init()
    
    Observable.from(AppManager.shared.blocks)
      .filter { block in
        AppManager.shared.settingData?.days.contains(block.weekday) ?? false
      }
      .map { blocks in
        MainBlockViewModel(blocks)
      }
      .toArray()
      .asObservable()
      .bind(to: self.output.blockViewModels)
      .disposed(by: self.disposeBag)
    
    self.output.blockViewModels
      .filter { !$0.isEmpty }
      .bind { [weak self] array in
        guard let self = self else { return }
        let runTimes = array.map { $0.output.runTime }
        
        Observable
          .combineLatest(runTimes) { $0.reduce(0, +) }
          .bind(to: self.output.sumRunTime)
          .disposed(by: self.disposeBag)
      }
      .disposed(by: self.disposeBag)
    
    self.input.refreshDidTap
      .map { _ -> (Bool, Int) in
        guard let refreshDate = AppManager.shared.refreshDate else { return (true, 0) }
        let distance = refreshDate.distance(to: Date())
        return (distance > TimeInterval(AppManager.shared.refreshInterval), Int(distance))
      }
      .bind { [weak self] state, interval in
        switch state {
        case true:
          AppManager.shared.refreshDate = Date()
          
          let inTpye = UpdateType.refresh
          let viewModel = UpdateViewModel(inTpye)
          let scene = Scene.update(viewModel)
          self?.coordinator.transition(scene: scene, style: .root)
          
        case false:
          self?.coordinator.toast("\(AppManager.shared.refreshInterval - interval)초 후 데이터 갱신이 가능합니다")
        }
      }
      .disposed(by: self.disposeBag)
    
    self.input.historyDidTap
      .throttle(.seconds(2), scheduler: MainScheduler.instance)
      .bind { [weak self] in
        let scene = Scene.history
        self?.coordinator.transition(scene: scene, style: .push)
      }
      .disposed(by: self.disposeBag)
    
    self.input.settingDidTap
      .throttle(.seconds(2), scheduler: MainScheduler.instance)
      .bind { [weak self] in
        let scene = Scene.setting
        self?.coordinator.transition(scene: scene, style: .push)
      }
      .disposed(by: self.disposeBag)
  }
}
