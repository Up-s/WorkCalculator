//
//  HistoryViewModel.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/13.
//

import Foundation

import RxCocoa
import RxSwift
import UPsKit

final class HistoryViewModel: BaseViewModel {
    
    struct Input {
        let viewDidAppear = PublishRelay<Void>()
    }
    
    struct Output {
        let blocks = BehaviorRelay<[BlockModel]>(value: [])
    }
    
    // MARK: - Property
    
    let input = Input()
    let output = Output()
    
    
    
    // MARK: - Interface
    
    init() {
        super.init()
        
        self.input.viewDidAppear
            .flatMap {
                FirebaseProvider.getHistoryBlock()
            }
            .map { getData -> [BlockModel] in
                let realmData = RealmManager.read() ?? []
                return getData + realmData
            }
            .flatMap { getBlocks in
                Observable.from(getBlocks)
                    .toArray()
                    .map { blocks in
                        blocks.sorted { $0.date > $1.date }
                    }
            }
            .bind(to: self.output.blocks)
            .disposed(by: self.disposeBag)
    }
}
