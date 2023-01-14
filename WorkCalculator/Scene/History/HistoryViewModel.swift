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
        let dayBlocks = BehaviorRelay<[DayBlockModel]>(value: [])
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
            .flatMap { getBlocks in
                return Observable.from(getBlocks)
                    .groupBy { $0.groupKey }
                    .flatMap { $0.toArray() }
                    .toArray()
                    .map { blocks in
                        blocks
                            .sorted { $0[0].date > $1[0].date }
                            .map { inBlocks in
                                inBlocks
                                    .sorted { $0.state.index < $1.state.index }
                            }
                            .map { inBlocks in
                                DayBlockModel(timeBlocks: inBlocks)
                            }
                    }
                    .asObservable()
            }
            .bind(to: self.output.dayBlocks)
            .disposed(by: self.disposeBag)
        
        
        
    }
}
