//
//  UpdateViewModel.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/11.
//

import Foundation

import RxCocoa
import RxSwift
import UPsKit

enum UpdateType {
    case refresh
    case share(String)
    case shareCancel
    case setting(SettingModel)
}

final class UpdateViewModel: BaseViewModel {
    
    struct Input {
        let viewDidAppear = PublishRelay<Void>()
    }
    
    struct Output {
        let progress = PublishRelay<Int>()
    }
    
    // MARK: - Property
    
    let input = Input()
    let output = Output()
    
    let inType: BehaviorRelay<UpdateType>
    private let timeObserver = Observable<Int>.interval(.milliseconds(5), scheduler: MainScheduler.instance)
    private let errorObserver = PublishRelay<Void>()
    
    
    
    // MARK: - Interface
    
    init(_ inType: UpdateType) {
        self.inType = BehaviorRelay<UpdateType>(value: inType)
        
        super.init()
        
        
        Observable
            .combineLatest(
                self.input.viewDidAppear.asObservable(),
                self.timeObserver.asObservable()
            ) { _, progress in
                return progress
            }
            .bind(to: self.output.progress)
            .disposed(by: self.disposeBag)
        
        self.input.viewDidAppear
            .flatMap {
                switch inType {
                case .refresh:
                    return FirebaseProvider.getSettingData()
                    
                case .share(let id):
                    return FirebaseProvider.share(id)
                    
                case .shareCancel:
                    return FirebaseProvider.shareCancel()
                    
                case .setting(let data):
                    return FirebaseProvider.setSettingData(data)
                }
            }
            .catch { [weak self] error in
                self?.debugLog(#function, #line, error)
                self?.errorObserver.accept(())
                return Observable.empty()
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
        
        self.errorObserver
            .delay(.seconds(4), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                let scene = Scene.splash
                self?.coordinator.transition(scene: scene, style: .root)
            }
            .disposed(by: self.disposeBag)
    }
}
