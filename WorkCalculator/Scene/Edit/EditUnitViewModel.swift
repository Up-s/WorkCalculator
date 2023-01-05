//
//  EditUnitViewModel.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/05.
//

import Foundation

import RxCocoa
import RxSwift
import UPsKit

final class EditUnitViewModel: BaseViewModel {
    
    struct Input {
        let startDidTap = PublishRelay<Void>()
        let endDidTap = PublishRelay<Void>()
        let restDidTap = PublishRelay<Void>()
    }
    
    struct Output {
        let startTime = BehaviorRelay<String>(value: "00:00")
        let endTime = BehaviorRelay<String>(value: "00:00")
        let restTime = BehaviorRelay<String>(value: "00:00")
        let runTime = BehaviorRelay<String>(value: "0시간 00분")
    }
    
    // MARK: - Property
    
    let input = Input()
    let output = Output()
    
    let day: DateManager.Day
    private let userDefault = UserDefaults.standard
    private let encoder = PropertyListEncoder()
    private let decoder = PropertyListDecoder()
    
    let startTimeBlock = BehaviorRelay<TimeBlockModel?>(value: nil)
    let endTimeBlock = BehaviorRelay<TimeBlockModel?>(value: nil)
    let restTimeBlock = BehaviorRelay<TimeBlockModel?>(value: nil)
    let runTime = BehaviorRelay<Int>(value: 0)
    
    
    
    // MARK: - Interface
    
    init(_ day: DateManager.Day) {
        self.day = day
        
        super.init()
        
        Observable.just(day.startKey.rawValue)
            .map { [weak self] key -> TimeBlockModel? in
                guard
                    let self = self,
                    let data = self.userDefault.object(forKey: key) as? Data,
                    let dataModel = try? self.decoder.decode(TimeBlockModel.self, from: data)
                else { return nil }
                return dataModel
            }
            .bind(to: self.startTimeBlock)
            .disposed(by: self.disposeBag)
        
        self.startTimeBlock
            .compactMap { $0?.intervalString }
            .bind(to: self.output.startTime)
            .disposed(by: self.disposeBag)
        
        self.startTimeBlock
            .compactMap { $0 }
            .bind { [weak self] timeBlock in
                let key = day.startKey.rawValue
                guard
                    let self = self,
                    let data = try? self.encoder.encode(timeBlock)
                else { return }
                self.userDefault.set(data, forKey: key)
                self.userDefault.synchronize()
            }
            .disposed(by: self.disposeBag)
        
        self.input.startDidTap
            .bind { [weak self] in
                guard let self = self else { return }
                
                let viewModel = PickerViewModel(self.day, .start)
                let scene: Scene = .picker(viewModel)
                self.coordinator.transition(scene: scene, style: .modal(.overFullScreen), animated: false)
                
                viewModel.timeBlock
                    .bind(to: self.startTimeBlock)
                    .disposed(by: viewModel.disposeBag)
            }
            .disposed(by: self.disposeBag)
        
        
        
        Observable.just(day.endKey.rawValue)
            .map { [weak self] key -> TimeBlockModel? in
                guard
                    let self = self,
                    let data = self.userDefault.object(forKey: key) as? Data,
                    let dataModel = try? self.decoder.decode(TimeBlockModel.self, from: data)
                else { return nil }
                return dataModel
            }
            .bind(to: self.endTimeBlock)
            .disposed(by: self.disposeBag)
        
        self.endTimeBlock
            .compactMap { $0?.intervalString }
            .bind(to: self.output.endTime)
            .disposed(by: self.disposeBag)
        
        self.endTimeBlock
            .compactMap { $0 }
            .bind { [weak self] timeBlock in
                let key = day.endKey.rawValue
                guard
                    let self = self,
                    let data = try? self.encoder.encode(timeBlock)
                else { return }
                self.userDefault.set(data, forKey: key)
                self.userDefault.synchronize()
            }
            .disposed(by: self.disposeBag)
        
        self.input.endDidTap
            .withLatestFrom(self.startTimeBlock) { _, start -> Bool in
                if start == nil {
                    
                    self.coordinator.alert(
                        title: "출근 시간을 먼저 설정해 주세요",
                        actions: [UPsAlertCancelAction()]
                    )
                }
                
                return start != nil
            }
            .filter { $0 }
            .map { _ in }
            .bind { [weak self] in
                guard let self = self else { return }
                
                let viewModel = PickerViewModel(self.day, .end)
                let scene: Scene = .picker(viewModel)
                self.coordinator.transition(scene: scene, style: .modal(.overFullScreen), animated: false)
                
                viewModel.timeBlock
                    .bind(to: self.endTimeBlock)
                    .disposed(by: viewModel.disposeBag)
            }
            .disposed(by: self.disposeBag)
        
        
        
        Observable.just(day.restKey.rawValue)
            .map { [weak self] key -> TimeBlockModel? in
                guard
                    let self = self,
                    let data = self.userDefault.object(forKey: key) as? Data,
                    let dataModel = try? self.decoder.decode(TimeBlockModel.self, from: data)
                else { return nil }
                return dataModel
            }
            .bind(to: self.restTimeBlock)
            .disposed(by: self.disposeBag)
        
        self.restTimeBlock
            .compactMap { $0?.intervalString }
            .bind(to: self.output.restTime)
            .disposed(by: self.disposeBag)
        
        self.restTimeBlock
            .compactMap { $0 }
            .bind { [weak self] timeBlock in
                let key = day.restKey.rawValue
                guard
                    let self = self,
                    let data = try? self.encoder.encode(timeBlock)
                else { return }
                self.userDefault.set(data, forKey: key)
                self.userDefault.synchronize()
            }
            .disposed(by: self.disposeBag)
        
        self.input.restDidTap
            .withLatestFrom(self.startTimeBlock) { _, start -> Bool in
                if start == nil {
                    
                    self.coordinator.alert(
                        title: "출근 시간을 먼저 설정해 주세요",
                        actions: [UPsAlertCancelAction()]
                    )
                }
                
                return start != nil
            }
            .filter { $0 }
            .map { _ in }
            .bind { [weak self] in
                guard let self = self else { return }
                
                let viewModel = PickerViewModel(self.day, .rest)
                let scene: Scene = .picker(viewModel)
                self.coordinator.transition(scene: scene, style: .modal(.overFullScreen), animated: false)
                
                viewModel.timeBlock
                    .bind(to: self.restTimeBlock)
                    .disposed(by: viewModel.disposeBag)
            }
            .disposed(by: self.disposeBag)
        
        
        
        Observable
            .combineLatest(
                self.startTimeBlock.asObservable(),
                self.endTimeBlock.asObservable(),
                self.restTimeBlock.asObservable()
            ) { inStartBlock, inEndBlock, inRestBlock -> Int? in
                guard
                    let startBlock = inStartBlock?.interval,
                    let endBlock = inEndBlock?.interval
                else { return nil }
                
                let restInterval = inRestBlock?.interval ?? 0
                
                return endBlock - startBlock - restInterval
            }
            .compactMap { $0 }
            .bind(to: self.runTime)
            .disposed(by: self.disposeBag)
        
        self.runTime
            .map { String(format: "%d시간 %02d분", ($0 / 60), ($0 % 60)) }
            .bind(to: self.output.runTime)
            .disposed(by: self.disposeBag)
    }
}
