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
    
    private let timeBlockProvider = PublishRelay<[TimeBlockModel]>()
    private let temp = BehaviorRelay<[[TimeBlockModel]]>(value: [])
    
    
    // MARK: - Interface
    
    init() {
        super.init()
        
        self.input.viewDidAppear
            .flatMap {
                UserDefaultsManager.firebaseID == nil ?
                    FirebaseProvider.create() :
                    FirebaseProvider.getSettingData()
            }
            .catch { [weak self] error in
                self?.debugLog(#function, #line, error)
                return FirebaseProvider.create()
            }
            .map { TimeBlockModel.create }
            .flatMap { blocks in
                Observable.from(blocks)
                    .flatMap { block in
                        FirebaseProvider.getTimeBlock(block)
                    }
                    .groupBy { $0.groupKey }
                    .flatMap { $0.toArray() }
                    .toArray()
                    .map { temp in
                        temp.sorted { $0[0].date < $1[0].date }
                    }
                    .map { temp in
                        temp.map { block in
                            block.sorted { $0.state.index < $1.state.index }
                        }
                    }
                    .asObservable()
            }
            .bind { [weak self] blocks in
                AppManager.shared.timeBlocks = blocks
                
                let scene = Scene.edit
                self?.coordinator.transition(scene: scene, style: .root)
            }
            .disposed(by: self.disposeBag)
    }
}
