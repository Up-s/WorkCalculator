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
        let inputType = BehaviorRelay<Int?>(value: nil)
        let baseHour = BehaviorRelay<Int?>(value: nil)
        let baseHourService = BehaviorRelay<Int?>(value: nil)
    }
    
    struct Output {
        let settingData = BehaviorRelay<SettingModel?>(value: nil)
        let inputType = BehaviorRelay<Int?>(value: nil)
        let baseHour = BehaviorRelay<String?>(value: nil)
    }
    
    
    
    // MARK: - Property
    
    let input = Input()
    let output = Output()
    
    
    
    // MARK: - Interface
    
    init() {
        super.init()
        
        Observable.just(AppManager.shared.settingData)
            .bind(to: self.output.settingData)
            .disposed(by: self.disposeBag)
        
        Observable.just(UserDefaultsManager.inputType)
            .bind(to: self.output.inputType)
            .disposed(by: self.disposeBag)
        
        
        
        self.input.inputType
            .compactMap { $0 }
            .bind {
                UserDefaultsManager.inputType = $0
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
        
        self.input.baseHourService
            .map { _ in }
            .flatMap { FirebaseProvider.setSettingData() }
            .subscribe(
                onError: { [weak self] error in
                    guard let self = self else { return }
                    self.debugLog(#function, #line, error)
                }
            )
            .disposed(by: self.disposeBag)
    }
}
