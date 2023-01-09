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
    
    init(_ timeBlock: TimeBlockModel) {
        super.init()
        
        Observable.just(timeBlock.info)
            .bind(to: self.output.title)
            .disposed(by: self.disposeBag)
        
        Observable.just(timeBlock.state)
            .bind(to: self.output.state)
            .disposed(by: self.disposeBag)
        
        self.input.cancelDidTap
            .bind { [weak self] in
                self?.coordinator.dismiss(animated: false)
            }
            .disposed(by: self.disposeBag)
        
        self.input.okDidTap
            .bind { [weak self] (hour, min) in
                var editTimeBlock = timeBlock
                editTimeBlock.hour = hour
                editTimeBlock.min = min
                self?.timeBlock.accept(editTimeBlock)
                self?.coordinator.dismiss(animated: false)
            }
            .disposed(by: self.disposeBag)
    }
}

