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
    }
    
    // MARK: - Property
    
    let input = Input()
    let output = Output()
    
    let timeBlock = PublishRelay<TimeBlockModel>()
    
    
    
    // MARK: - Interface
    
    init(_ day: DateManager.Day, _ state: DateManager.State) {
        super.init()
        
        Observable.just(day.ko + "요일 " + state.title)
            .bind(to: self.output.title)
            .disposed(by: self.disposeBag)
        
        Observable.just(state)
            .bind(to: self.output.state)
            .disposed(by: self.disposeBag)
        
        self.input.cancelDidTap
            .bind { [weak self] in
                self?.coordinator.dismiss(animated: false)
            }
            .disposed(by: self.disposeBag)
        
        self.input.okDidTap
            .bind { [weak self] (hour, min) in
                let timeBlock = TimeBlockModel(day: day, state: state, hour: hour, min: min)
                self?.timeBlock.accept(timeBlock)
                self?.coordinator.dismiss(animated: false)
            }
            .disposed(by: self.disposeBag)
    }
}

