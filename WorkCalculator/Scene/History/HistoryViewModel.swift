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
        let blocks = BehaviorRelay<[[TimeBlockModel]]>(value: [])
    }
    
    // MARK: - Property
    
    let input = Input()
    let output = Output()
    
    
    
    
    // MARK: - Interface
    
    init() {
        super.init()
        
        self.input.viewDidAppear
            .flatMap {
                FirebaseProvider.getAllTimeBlock()
            }
            .map { getData -> [TimeBlockModel] in
                let realmData = RealmManager.read() ?? []
                return getData + realmData
            }
            .flatMap { blocks in
                Observable.from(blocks)
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
            .bind(to: self.output.blocks)
            .disposed(by: self.disposeBag)
        
        

    }
}
