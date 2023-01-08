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
            .delay(.seconds(2), scheduler: MainScheduler.instance)
            .flatMap {
                UserDefaultsManager.firebaseID == nil ?
                    FirebaseProvider.create() :
                    FirebaseProvider.getSettingData()
            }
            .subscribe(
                onNext: { [weak self] in
//                    self?.coordinator.transition(scene: Scene.edit, style: .root)
                    
                    let blocks = self!.createTimeBlock()
                    self?.timeBlockProvider.accept(blocks)
                },
                onError: { [weak self] error in
                    self?.debugLog(#function, #line, error)
                }
            )
            .disposed(by: self.disposeBag)
        
        
        self.timeBlockProvider
            .flatMap { blocks in
                print("\n-----------------------------")
                return Observable.from(blocks)
                    .flatMap { block in
                        FirebaseProvider.getTimeBlock(block)
                    }
            }
            .groupBy { $0.groupKey }
            .flatMap { $0.toArray() }
            .toArray()
            .map { temp in
                temp.sorted { $0[0].date < $1[0].date }
            }
            .asObservable()
            .bind(to: self.temp)
            .disposed(by: self.disposeBag)
        
        self.temp
            .bind {
                print("\n-----------------------------", $0)
            }
            .disposed(by: self.disposeBag)
        
        
//        let blocks = self.createTimeBlock()
//
//        Observable.from(blocks)
//            .flatMap { block in
//                FirebaseProvider.getTimeBlock(block)
//            }
//            .toArray()
            
        
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
