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
    let changeViewDidTap = PublishRelay<Void>()
    let refreshDidTap = PublishRelay<Void>()
    let historyDidTap = PublishRelay<Void>()
    let settingDidTap = PublishRelay<Void>()
    let weekPayTouchDown = PublishRelay<Void>()
    let weekPayTouchOut = PublishRelay<Void>()
  }
  
  struct Output {
    let blockViewModels = BehaviorRelay<[MainBlockViewModel]>(value: [])
    let sumRunTime = BehaviorRelay<Int>(value: 0)
    let notionData = PublishRelay<NotionModel?>()
    let weekPay = BehaviorRelay<String?>(value: nil)
  }
  
  // MARK: - Property
  
  let input = Input()
  let output = Output()
  
  var mainView: MainViewProtocol {
    switch UserDefaultsManager.mainType {
    case .week:
      return MainWeekView()

    case .day:
      return MainDayView()
    }
  }
  
  private var messageTimerOb: Observable<Int> {
    #if Debug
    return Observable<Int>.timer(.seconds(1), period: .seconds(3), scheduler: MainScheduler.instance)
    #else
    return Observable<Int>.timer(.seconds(1), period: .seconds(60), scheduler: MainScheduler.instance)
    #endif
  }
  
  // 오늘 전날까지 근무한 일수
  private var workdayCount: Int {
    let days = AppManager.shared.settingData?.days
      .map { $0.weekdayInt }
      .reversed() ?? []
    let todayWeekdayInt = Date().weekdayInt()
    var count = 0
    for i in days {
      guard i < todayWeekdayInt else { continue }
      count += 1
    }
    return count
  }
  
  private var todayBlock: BlockModel? {
    return self.output.blockViewModels.value
      .filter { $0.inBlock.weekday.weekdayInt == Date().weekdayInt() }
      .first?
      .inBlock
  }
  
  private var currentTime: Int {
    let hour = Date().hourInt() * 60
    let min = Date().minuteInt()
    return hour + min
  }
  
  private var todayRunTime: Int {
    guard let todayStart = self.todayBlock?.startTime else { return 0 }
    let todayRunTime = self.currentTime - todayStart
    if todayRunTime < 0 {
      return 0
      
    } else {
      return todayRunTime
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
      .map { $0.map { $0.output.runTime } }
      .flatMap { Observable.combineLatest($0)}
      .map { $0.reduce(0, +) }
      .bind(to: self.output.sumRunTime)
      .disposed(by: self.disposeBag)
      
    
    self.input.changeViewDidTap
      .bind { [weak self] _ in
        guard let self = self else { return }
        
        switch UserDefaultsManager.mainType {
        case .week:
          UserDefaultsManager.mainType = .day
          
        case .day:
          UserDefaultsManager.mainType = .week
        }
        
        let viewModel = MainViewModel()
        let scene = Scene.main(viewModel)
        self.coordinator.transition(scene: scene, style: .root)
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
    
    
    self.messageTimerOb
      .map { [weak self] _ -> NotionModel? in
        guard let self = self else { return nil }
        
        // 현재까지 총 근무 시간
        let sumRunTime = self.output.sumRunTime.value
        
        if sumRunTime == 0 {
          return AppManager.shared.notionData
            .filter { $0.tag == .white }
            .first
        }
        
        // 주간 총 근무 시간
        let workBaseHour = (AppManager.shared.settingData?.workBaseHour ?? 0) * 60
        
        if sumRunTime > workBaseHour { // gray
          return AppManager.shared.notionData
            .filter { $0.tag == .gray }
            .first
        }
        
        // 근무일수
        let daysCount = AppManager.shared.settingData?.days.count ?? 0
        
        // 오늘 전날까지 근무한 일수
        let workdayCount = self.workdayCount
        
        // 전날까지 평균 근무시간 목표값
        let tx = (workBaseHour / daysCount) * workdayCount
        
        // 오늘 현재까지 근무 시간
        let todayRunTime = self.todayRunTime
        
        switch sumRunTime {
        case ..<(tx + todayRunTime - (1 * 60)): // red
          return AppManager.shared.notionData
            .filter { $0.tag == .red }
            .first
          
        case (tx + todayRunTime - (1 * 60)) ..< (tx + todayRunTime + 5): // blue
          return AppManager.shared.notionData
            .filter { $0.tag == .blue }
            .first
          
        case (tx + todayRunTime + 5)...: // cyan
          return AppManager.shared.notionData
            .filter { $0.tag == .cyan }
            .first
          
        default:
          return nil
        }
      }
      .bind(to: self.output.notionData)
      .disposed(by: self.disposeBag)
    
    
    self.input.weekPayTouchDown
      .withLatestFrom(self.output.sumRunTime)
      .map { sumRunTime -> String? in
        guard let hourlyWage = UserDefaultsManager.hourlyWage else {
          return "-"
        }
        
        let sumRunTimeHour = sumRunTime / 60
        let sumRunTimeMin = sumRunTime % 60
        
        switch sumRunTimeMin == 0 {
        case true:
          let sum = hourlyWage * sumRunTimeHour
          return sum.toWon + "원"
          
        case false:
          let minWage = CGFloat(hourlyWage) / 60.0
          let sum = Int(minWage * CGFloat(sumRunTime))
          return sum.toWon + "원"
        }
      }
      .bind(to: self.output.weekPay)
      .disposed(by: self.disposeBag)
    
    
    self.input.weekPayTouchOut
      .map { _ -> String in
        return "💰"
      }
      .bind(to: self.output.weekPay)
      .disposed(by: self.disposeBag)
  }
}
