//
//  NumberPadViewModel.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/08.
//

import Foundation

import RxCocoa
import RxSwift
import UPsKit

final class NumberPadViewModel: BaseViewModel {
    
    struct Input {
        let cancelDidTap = PublishRelay<Void>()
        let okDidTap = PublishRelay<Void>()
        let inputNumber = PublishRelay<Int>()
    }
    
    struct Output {
        let title = BehaviorRelay<String?>(value: nil)
        let timer = BehaviorRelay<String?>(value: nil)
        let numberPadList = BehaviorRelay<[String]>(value: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "", "0", "⌫"])
    }
    
    // MARK: - Property
    
    let input = Input()
    let output = Output()
    
    let timer = BehaviorRelay<String>(value: "")
    let callbackOb = PublishRelay<(DateManager.State, Int)>()
    
    
    
    // MARK: - Interface
    
    init(_ state: DateManager.State, _ block: BlockModel) {
        super.init()
        
        Observable.just(block.getInfo(state) )
            .bind(to: self.output.title)
            .disposed(by: self.disposeBag)
        
        Observable.just(block.getIntervalString(state))
            .bind(to: self.output.timer)
            .disposed(by: self.disposeBag)
        
        self.input.cancelDidTap
            .bind { [weak self] in
                self?.coordinator.dismiss(animated: false)
            }
            .disposed(by: self.disposeBag)
        
        self.input.okDidTap
            .withLatestFrom(self.timer)
            .compactMap { [weak self] timer -> (Int, Int)? in
                guard let self = self else { return nil }
                
                guard timer.count == 4 else {
                    self.coordinator.toast("4자리 모두 입력해주세요")
                    return nil
                }
                
                let timerInt = Int(timer)!
                let hour = timerInt / 100
                let min = timerInt % 100
                
                guard hour <= 24 else {
                    self.coordinator.toast("24시간 아래로 입력해주세요")
                    return nil
                }
                
                guard min < 60 else {
                    self.coordinator.toast("60분 아래로 입력해주세요")
                    return nil
                }
                
                let maxTime = 24 * 60
                let runTime = (hour * 60) + min
                
                guard runTime <= maxTime else {
                    self.coordinator.toast("24:00 까지 입력 가능합니다")
                    return nil
                }
                
                return (hour, min)
            }
            .flatMap { hour, min in
                FirebaseProvider.setBlock(
                    key: block.key,
                    state: state,
                    time: (hour * 60) + min
                )
            }
            .subscribe(
                onNext: { [weak self] time in
                    self?.callbackOb.accept((state, time))
                    self?.coordinator.dismiss(animated: false)
                },
                onError: { [weak self] error in
                    self?.debugLog(#function, #line, error)
                }
            )
            .disposed(by: self.disposeBag)
        
        self.input.inputNumber
            .filter { [weak self] index in
                if index == 11 {
                    return true
                }
                
                let count = self?.timer.value.count ?? 0
                return count < 4
            }
            .withLatestFrom(self.output.numberPadList) { [weak self] index, list -> String? in
                guard let self = self else { return nil }
                var timerString = self.timer.value
                
                switch index {
                case 0...8, 10:
                    let number = list[index]
                    timerString += number
                    
                case 11:
                    guard self.timer.value.count > 0 else { return nil }
                    timerString.removeLast()
                    
                default:
                    return timerString
                }
                
                return timerString
            }
            .compactMap { $0 }
            .bind(to: self.timer)
            .disposed(by: self.disposeBag)
        
        self.timer
            .skip(1)
            .map {
                $0.numberPattern(pattern: .hourMin)
            }
            .bind(to: self.output.timer)
            .disposed(by: self.disposeBag)
    }
}
