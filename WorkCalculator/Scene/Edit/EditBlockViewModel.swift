//
//  EditBlockViewModel.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/05.
//

import Foundation

import RxCocoa
import RxSwift
import UPsKit

final class EditBlockViewModel: BaseViewModel {
  
  struct Input {
    let startDidTap = PublishRelay<Void>()
    let endDidTap = PublishRelay<Void>()
    let restDidTap = PublishRelay<Void>()
  }
  
  struct Output {
    let startTime = BehaviorRelay<Int>(value: 0)
    let endTime = BehaviorRelay<Int>(value: 0)
    let restTime = BehaviorRelay<Int>(value: 0)
    let runTime = BehaviorRelay<Int>(value: 0)
  }
  
  // MARK: - Property
  
  let input = Input()
  let output = Output()
  
  var inBlock: BlockModel
  private let presentOb = PublishRelay<(DateManager.State, Int)>()
  private let callbackOb = PublishRelay<(DateManager.State, Int)>()
  
  
  
  
  // MARK: - Interface
  
  init(_ block: BlockModel) {
    self.inBlock = block
    
    super.init()
    
    Observable.just(self.inBlock.getTime(.start))
      .bind(to: self.output.startTime)
      .disposed(by: self.disposeBag)
    
    Observable.just(self.inBlock.getTime(.end))
      .bind(to: self.output.endTime)
      .disposed(by: self.disposeBag)
    
    Observable.just(self.inBlock.getTime(.rest))
      .bind(to: self.output.restTime)
      .disposed(by: self.disposeBag)
    
    
    
    self.input.startDidTap
      .withLatestFrom(self.output.startTime)
      .map { (DateManager.State.start, $0) }
      .bind(to: self.presentOb)
      .disposed(by: self.disposeBag)
    
    self.input.endDidTap
      .withLatestFrom(self.output.endTime)
      .map { (DateManager.State.end, $0) }
      .bind(to: self.presentOb)
      .disposed(by: self.disposeBag)
    
    self.input.restDidTap
      .withLatestFrom(self.output.restTime)
      .map { (DateManager.State.rest, $0) }
      .bind(to: self.presentOb)
      .disposed(by: self.disposeBag)
    
    
    
    self.presentOb
      .bind { [weak self] state, time in
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
      ) { start, end, rest -> Int in
        switch end == 0 {
        case true:
          return 0
          
        case false:
          return end - start - rest
        }
      }
      .bind(to: self.output.runTime)
      .disposed(by: self.disposeBag)
  }}
