//
//  SettingViewModel.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/07.
//

import Foundation

import RxCocoa
import RxSwift
import UPsKit

final class SettingViewModel: BaseViewModel {
    
    struct Input {
        let selectDay = PublishRelay<DateManager.Day>()
        let baseHour = BehaviorRelay<Int?>(value: nil)
        let inputType = BehaviorRelay<Int?>(value: nil)
        let saveDidTap = PublishRelay<Void>()
    }
    
    struct Output {
        let selectDays = BehaviorRelay<[DateManager.Day]>(value: AppManager.shared.settingData?.days ?? [])
        let allDays = BehaviorRelay<[DateManager.Day]>(value: DateManager.Day.allCases)
        let baseHour = BehaviorRelay<String?>(value: nil)
        let inputType = BehaviorRelay<Int?>(value: nil)
    }
    
    
    
    // MARK: - Property
    
    let input = Input()
    let output = Output()
    
    
    // MARK: - Interface
    
    init() {
        super.init()
        
        self.input.selectDay
            .withLatestFrom(self.output.selectDays) { item, days in
                var tempDays = days
                
                if let index = tempDays.firstIndex(of: item) {
                    tempDays.remove(at: index)
                    
                } else {
                    tempDays.append(item)
                }
                
                return tempDays.sorted { $0.weekdayInt < $1.weekdayInt }
            }
            .bind(to: self.output.selectDays)
            .disposed(by: self.disposeBag)
        
        self.output.selectDays
            .bind { days in
                AppManager.shared.settingData?.days = days
            }
            .disposed(by: self.disposeBag)
        
        self.input.baseHour
            .compactMap { $0 }
            .bind { [weak self] hour in
                AppManager.shared.settingData?.workBaseHour = hour
                
                let text = String(hour) + "시간"
                self?.output.baseHour.accept(text)
            }
            .disposed(by: self.disposeBag)
        
        self.input.inputType
            .compactMap { $0 }
            .bind {
                UserDefaultsManager.inputType = $0
            }
            .disposed(by: self.disposeBag)
        
        self.input.saveDidTap
            .flatMap {
                FirebaseProvider.setSettingData()
            }
            .subscribe(
                onNext: { [weak self] in
                    let scene = Scene.splash
                    self?.coordinator.transition(scene: scene, style: .root)
                },
                onError: { [weak self] error in
                    self?.debugLog(#function, #line, error)
                }
            )
            .disposed(by: self.disposeBag)
    }
}
