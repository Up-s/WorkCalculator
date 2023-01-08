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
        let baseHour = BehaviorRelay<Int?>(value: nil)
        let inputType = BehaviorRelay<Int?>(value: nil)
    }
    
    struct Output {
        let baseHour = BehaviorRelay<String?>(value: nil)
        let inputType = BehaviorRelay<Int?>(value: nil)
    }
    
    
    
    // MARK: - Property
    
    let input = Input()
    let output = Output()
    
    
    
    // MARK: - Interface
    
    init() {
        super.init()
        
        self.input.baseHour
            .compactMap { $0 }
            .bind { [weak self] hour in
                AppManager.shared.settingData?.workBaseHour = hour
                
                let text = String(hour) + "시간"
                self?.output.baseHour.accept(text)
            }
            .disposed(by: self.disposeBag)
        
        self.input.baseHour
            .compactMap { $0 }
            .map { _ in }
            .debounce(.seconds(2), scheduler: MainScheduler.instance)
            .flatMap { FirebaseProvider.setSettingData() }
            .subscribe(
                onError: { [weak self] error in
                    guard let self = self else { return }
                    self.debugLog(#function, #line, error)
                }
            )
            .disposed(by: self.disposeBag)
        
        self.input.inputType
            .compactMap { $0 }
            .bind {
                UserDefaultsManager.inputType = $0
            }
            .disposed(by: self.disposeBag)
        
    }
}
