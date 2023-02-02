//
//  PickerViewModel.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/05.
//

import Foundation

import RxCocoa
import RxSwift
import UPsKit

final class PickerViewModel: BaseViewModel {
  
  struct Input {
    let cancelDidTap = PublishRelay<Void>()
    let okDidTap = PublishRelay<(Int, Int)>()
  }
  
  struct Output {
    let title = BehaviorRelay<String?>(value: nil)
    let time = BehaviorRelay<Int>(value: 0)
  }
  
  // MARK: - Property
  
  let input = Input()
  let output = Output()
  
  let callbackOb = PublishRelay<(DateManager.State, Int)>()
  
  
  
  // MARK: - Interface
  
  init(_ state: DateManager.State, _ block: BlockModel) {
    super.init()
    
    Observable.just(block.getInfo(state) )
      .bind(to: self.output.title)
      .disposed(by: self.disposeBag)
    
    Observable.just(block.getTime(state))
      .bind(to: self.output.time)
      .disposed(by: self.disposeBag)
    
    self.input.cancelDidTap
      .bind { [weak self] in
        self?.coordinator.dismiss(animated: false)
      }
      .disposed(by: self.disposeBag)
    
    self.input.okDidTap
      .compactMap { [weak self] (hour, min) -> Int? in
        guard let self = self else { return nil }
        
        let maxTime = 24 * 60
        let runTime = (hour * 60) + min
        
        guard runTime <= maxTime else {
          self.coordinator.toast("24:00 까지 입력 가능합니다")
          return nil
        }
        
        return runTime
      }
      .flatMap { runTime in
        FirebaseProvider.setBlock(
          key: block.key,
          state: state,
          runTime: runTime
        )
      }
      .subscribe(
        onNext: { [weak self] runTime in
          self?.callbackOb.accept((state, runTime))
          self?.coordinator.dismiss(animated: false)
        },
        onError: { [weak self] error in
          self?.debugLog(#function, #line, error)
        }
      )
      .disposed(by: self.disposeBag)
  }
}

