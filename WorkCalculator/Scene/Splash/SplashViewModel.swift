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
    
    private let createProvider = PublishRelay<Void>()
    
    
    
    // MARK: - Interface
    
    init() {
        super.init()
        
        self.input.viewDidAppear
            .delay(.seconds(2), scheduler: MainScheduler.instance)
            .flatMap {
                UserDefaultsManager.firebaseID == nil ?
                    FirebaseProvider.create() :
                    FirebaseProvider.getSettingData()
            }
            .subscribe(
                onNext: { [weak self] in
                    self?.coordinator.transition(scene: Scene.edit, style: .root)
                },
                onError: { [weak self] error in
                    self?.debugLog(#function, #line, error)
                }
            )
            .disposed(by: self.disposeBag)
    }
}
