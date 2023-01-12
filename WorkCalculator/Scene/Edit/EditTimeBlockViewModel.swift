//
//  EditTimeBlockViewModel.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/05.
//

import Foundation

import RxCocoa
import RxSwift
import UPsKit

final class EditTimeBlockViewModel: BaseViewModel {
    
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
    
    private let userDefault = UserDefaults.standard
    private let encoder = PropertyListEncoder()
    private let decoder = PropertyListDecoder()
    
    let weekday: DateManager.Day
    let startTimeBlock: BehaviorRelay<TimeBlockModel>
    let endTimeBlock: BehaviorRelay<TimeBlockModel>
    let restTimeBlock: BehaviorRelay<TimeBlockModel>
    let runTime = BehaviorRelay<Int>(value: 0)
    private let presentTimeBlock = PublishRelay<TimeBlockModel>()
    private let callbackTimeBlock = PublishRelay<TimeBlockModel>()
    
    
    
    // MARK: - Interface
    
    init(_ timeBlock: [TimeBlockModel]) {
        self.weekday = timeBlock[0].weekday
        self.startTimeBlock = BehaviorRelay<TimeBlockModel>(value: timeBlock[0])
        self.endTimeBlock = BehaviorRelay<TimeBlockModel>(value: timeBlock[1])
        self.restTimeBlock = BehaviorRelay<TimeBlockModel>(value: timeBlock[2])
        
        super.init()
        
        self.presentTimeBlock
            .bind { [weak self] block in
                guard let self = self else { return }
                
                let scene: Scene
                
                let inputType: Int = AppManager.shared.settingData?.inputType ?? 0
                switch inputType {
                case 0:
                    let viewModel = PickerViewModel(block)
                    scene = .picker(viewModel)
                    
                    viewModel.timeBlock
                        .bind(to: self.callbackTimeBlock)
                        .disposed(by: viewModel.disposeBag)
                    
                case 1:
                    let viewModel = NumberPadViewModel(block)
                    scene = .numberPad(viewModel)
                    
                    viewModel.timeBlock
                        .bind(to: self.callbackTimeBlock)
                        .disposed(by: viewModel.disposeBag)
                    
                default:
                    fatalError()
                }
                
                self.coordinator.transition(scene: scene, style: .modal(.overFullScreen), animated: false)
            }
            .disposed(by: self.disposeBag)
        
        self.callbackTimeBlock
            .bind { block in
                switch block.state {
                case .start:
                    self.startTimeBlock.accept(block)
                    
                case .end:
                    self.endTimeBlock.accept(block)
                    
                case .rest:
                    self.restTimeBlock.accept(block)
                }
            }
            .disposed(by: self.disposeBag)
        
        
        
        self.startTimeBlock
            .map { $0.intervalString }
            .bind(to: self.output.startTime)
            .disposed(by: self.disposeBag)
        
        self.input.startDidTap
            .withLatestFrom(self.startTimeBlock)
            .bind(to: self.presentTimeBlock)
            .disposed(by: self.disposeBag)
        
        
        
        self.endTimeBlock
            .map { $0.intervalString }
            .bind(to: self.output.endTime)
            .disposed(by: self.disposeBag)
        
        self.input.endDidTap
            .withLatestFrom(self.endTimeBlock)
            .bind(to: self.presentTimeBlock)
            .disposed(by: self.disposeBag)
        
        
        
        self.restTimeBlock
            .map { $0.intervalString }
            .bind(to: self.output.restTime)
            .disposed(by: self.disposeBag)
        
        self.input.restDidTap
            .withLatestFrom(self.restTimeBlock)
            .bind(to: self.presentTimeBlock)
            .disposed(by: self.disposeBag)
        
        
        
        Observable
            .combineLatest(
                self.startTimeBlock.asObservable(),
                self.endTimeBlock.asObservable(),
                self.restTimeBlock.asObservable()
            ) { inStartBlock, inEndBlock, inRestBlock -> Int in
                let startBlock = inStartBlock.interval
                let endBlock = inEndBlock.interval
                let restInterval = inRestBlock.interval
                
                switch endBlock == 0 {
                case true:
                    return 0
                    
                case false:
                    return endBlock - startBlock - restInterval
                }
            }
            .bind(to: self.runTime)
            .disposed(by: self.disposeBag)
        
        self.runTime
            .map { String(format: "%d시간 %02d분", ($0 / 60), ($0 % 60)) }
            .bind(to: self.output.runTime)
            .disposed(by: self.disposeBag)
    }
}
