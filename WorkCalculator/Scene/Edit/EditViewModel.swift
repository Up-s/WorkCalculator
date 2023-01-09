//
//  EditViewModel.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/05.
//

import Foundation

import RxCocoa
import RxSwift
import UPsKit

final class EditViewModel: BaseViewModel {
    
    struct Input {
        let refreshDidTap = PublishRelay<Void>()
        let settingDidTap = PublishRelay<Void>()
    }
    
    struct Output {
        let sumRunTime = BehaviorRelay<Int>(value: 0)
    }
    
    // MARK: - Property
    
    let input = Input()
    let output = Output()
    
    let timeBlockViewModels = BehaviorRelay<[EditTimeBlockViewModel]>(value: [])
    
    
    
    // MARK: - Interface
    
    init() {
        super.init()
        
        Observable.from(AppManager.shared.timeBlocks)
            .map { blocks in
                EditTimeBlockViewModel(blocks)
            }
            .toArray()
            .asObservable()
            .bind(to: self.timeBlockViewModels)
            .disposed(by: self.disposeBag)
        
        self.timeBlockViewModels
            .filter { !$0.isEmpty }
            .bind { [weak self] array in
                guard let self = self else { return }
                let runTimes = array.map { $0.runTime }
                
                Observable
                    .combineLatest(runTimes) { $0.reduce(0, +) }
                    .bind(to: self.output.sumRunTime)
                    .disposed(by: self.disposeBag)
            }
            .disposed(by: self.disposeBag)
        
        self.input.refreshDidTap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                let scene = Scene.splash
                self?.coordinator.transition(scene: scene, style: .root)
            }
            .disposed(by: self.disposeBag)
        
        self.input.settingDidTap
            .bind { [weak self] in
                let scene = Scene.setting
                self?.coordinator.transition(scene: scene, style: .modal(.fullScreen))
            }
            .disposed(by: self.disposeBag)
    }
}
