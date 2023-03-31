//
//  MainBlockViewModel.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/05.
//

import Foundation

import RxCocoa
import RxSwift
import UPsKit

final class MainBlockViewModel: BaseViewModel {
  
  struct Input {
    let startDidTap = PublishRelay<Void>()
    let endDidTap = PublishRelay<Void>()
    let restDidTap = PublishRelay<Void>()
  }
  
  struct Output {
    let startTime = BehaviorRelay<Int?>(value: nil)
    let endTime = BehaviorRelay<Int?>(value: nil)
    let restTime = BehaviorRelay<Int>(value: 0)
    let runTime = BehaviorRelay<Int>(value: 0)
  }
  
  // MARK: - Property
  
  let input = Input()
  let output = Output()
  
  var inBlock: BlockModel
  private let presentOb = PublishRelay<(DateManager.State)>()
  private let callbackOb = PublishRelay<(DateManager.State, Int)>()
  
  
  
  
  // MARK: - Interface
  
  init(_ block: BlockModel) {
    self.inBlock = block
    
    super.init()
    
    Observable.just(self.inBlock.startTime)
      .bind(to: self.output.startTime)
      .disposed(by: self.disposeBag)
    
    Observable.just(self.inBlock.endTime)
      .bind(to: self.output.endTime)
      .disposed(by: self.disposeBag)
    
    Observable.just(self.inBlock.restTime)
      .bind(to: self.output.restTime)
      .disposed(by: self.disposeBag)
    
    
    
    self.input.startDidTap
      .map { DateManager.State.start }
      .bind(to: self.presentOb)
      .disposed(by: self.disposeBag)
    
    self.input.endDidTap
      .map { DateManager.State.end }
      .bind(to: self.presentOb)
      .disposed(by: self.disposeBag)
    
    self.input.restDidTap
      .map { DateManager.State.rest }
      .bind(to: self.presentOb)
      .disposed(by: self.disposeBag)
    
    
    
    self.presentOb
      .bind { [weak self] state in
        guard let self = self else { return }
        
        let scene: Scene
        
        let inputType: Int = AppManager.shared.settingData?.inputType ?? 0
        switch inputType {
        case 0:
          let viewModel = PickerViewModel(state, self.inBlock)
          viewModel.callbackOb
            .bind(to: self.callbackOb)
            .disposed(by: viewModel.disposeBag)
          
          scene = .picker(viewModel)
          
        case 1:
          let viewModel = NumberPadViewModel(state, self.inBlock)
          viewModel.callbackOb
            .bind(to: self.callbackOb)
            .disposed(by: viewModel.disposeBag)
          
          scene = .numberPad(viewModel)
          
        default:
          fatalError()
        }
        
        self.coordinator.transition(scene: scene, style: .modal(.overFullScreen), animated: false)
      }
      .disposed(by: self.disposeBag)
    
    self.callbackOb
      .bind { state, time in
        self.inBlock.updateTime(state, time: time)
        
        switch state {
        case .start:
          self.output.startTime.accept(time)
          
        case .end:
          self.output.endTime.accept(time)
          
        case .rest:
          self.output.restTime.accept(time)
        }
      }
      .disposed(by: self.disposeBag)
    
    Observable
      .combineLatest(
        self.output.startTime.asObservable(),
        self.output.endTime.asObservable(),
        self.output.restTime.asObservable()
      ) { [weak self] startTime, endTime, restTime -> Int in
        guard let self = self else { return 0 }
        guard let startTime = startTime else { return 0 }
        
        switch (self.inBlock.isToday && endTime == nil) {
        case true:
          let hour = Date().hourInt() * 60
          let min = Date().minuteInt()
          let currentTime = hour + min
          let sum = currentTime - startTime - restTime
          return sum
          
        case false:
          guard let endTime = endTime else { return 0 }
          return endTime - startTime - restTime
        }
      }
      .bind(to: self.output.runTime)
      .disposed(by: self.disposeBag)
  }
}
