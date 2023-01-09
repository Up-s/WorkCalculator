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
            .compactMap { [weak self] _ -> [TimeBlockModel]? in
                guard let self = self else { return nil }
                let blocks = self.createTimeBlock()
                return blocks
            }
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
    
    private func createTimeBlock() -> [TimeBlockModel] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        let today = Date()
        let weekday = today.weekdayInt()
        let blocks = DateManager.Day.allCases
            .map { day -> Date in
                let tempWeekday = day.weekdayInt - weekday
                let tempTimeInterval = TimeInterval(tempWeekday * 24 * 60 * 60)
                let tempDay = today + tempTimeInterval
                return tempDay
            }
            .flatMap { inDate -> [TimeBlockModel] in
                let inBlocks = DateManager.State.allCases
                    .map { inState -> TimeBlockModel in
                        return TimeBlockModel(
                            state: inState,
                            weekday: DateManager.Day(inDate.weekdayInt()),
                            year: inDate.yearInt(),
                            month: inDate.monthInt(),
                            day: inDate.dayInt(),
                            hour: 0,
                            min: 0
                        )
                    }
                return inBlocks
            }
        return blocks
    }
}
