//
//  SplashViewModel.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/05.
//

import Foundation

import RxCocoa
import RxSwift
import UPsKit

final class SplashViewModel: BaseViewModel {
    
    struct Input {
        let viewDidAppear = PublishRelay<Void>()
    }
    
    struct Output {
    }
    
    // MARK: - Property
    
    let input = Input()
    let output = Output()
    
    
    
    
    // MARK: - Interface
    
    init() {
        super.init()
        
        self.input.viewDidAppear
            .delay(.seconds(5), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                self?.coordinator.transition(scene: Scene.edit, style: .root)
            }
            .disposed(by: self.disposeBag)
    }
}
