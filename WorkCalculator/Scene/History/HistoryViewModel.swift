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
        let willCellIndex = BehaviorRelay<Int>(value: 0)
        let selectIndex = BehaviorRelay<Int>(value: 0)
    }
    
    struct Output {
        let title = PublishRelay<String>()
        let blocks = BehaviorRelay<[BlockModel]>(value: [])
        let block = BehaviorRelay<BlockModel?>(value: nil)
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
        
        self.input.willCellIndex
            .skip(1)
            .withLatestFrom(self.output.blocks) { $1[$0].yearMonth }
            .bind(to: self.output.title)
            .disposed(by: self.disposeBag)
        
        self.input.selectIndex
            .skip(1)
            .withLatestFrom(self.output.blocks) { $1[$0] }
            .bind(to: self.output.block)
            .disposed(by: self.disposeBag)
    }
}
