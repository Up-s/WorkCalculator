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
        let state = BehaviorRelay<DateManager.State?>(value: nil)
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
        
        self.input.cancelDidTap
            .bind { [weak self] in
                self?.coordinator.dismiss(animated: false)
            }
            .disposed(by: self.disposeBag)
        
        self.input.okDidTap
            .flatMap { hour, min in
                FirebaseProvider.setBlock(
                    key: block.key,
                    state: state,
                    time: (hour * 60) + min
                )
            }
            .subscribe(
                onNext: { [weak self] time in
                    self?.callbackOb.accept((state, time))
                    self?.coordinator.dismiss(animated: false)
                },
                onError: { [weak self] error in
                    self?.debugLog(#function, #line, error)
                }
            )
            .disposed(by: self.disposeBag)
    }
}

