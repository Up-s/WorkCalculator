//
//  SettingViewController.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/07.
//

import UIKit

import RxCocoa
import RxSwift
import UPsKit

final class SettingViewController: BaseViewController {
    
    // MARK: - Property
    
    private let rootView = SettingView()
    private let viewModel = SettingViewModel()
    
    
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = self.rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configure()
        self.bindViewModel()
    }
    
    
    
    // MARK: - Interface
    
    private func configure() {
        
    }
    
    private func bindViewModel() {
        self.rootView.naviView.leftButton.rx.tap
            .bind(to: self.viewModel.base.dismissDidTap)
            .disposed(by: self.disposeBag)
        
        self.rootView.inputTypeView.segmentedControl.rx.selectedSegmentIndex
            .filter { $0 != -1 }
            .bind(to: self.viewModel.input.inputType)
            .disposed(by: self.disposeBag)
        
        self.rootView.hourView.hourSlider.rx.value
            .skip(1)
            .map { Int($0) }
            .bind(to: self.viewModel.input.baseHour)
            .disposed(by: self.disposeBag)
        
        self.rootView.hourView.hourSlider.rx.value
            .skip(1)
            .map { Int($0) }
            .debounce(.seconds(2), scheduler: MainScheduler.instance)
            .bind(to: self.viewModel.input.baseHourService)
            .disposed(by: self.disposeBag)
        
        
        
        self.viewModel.output.settingData
            .compactMap { $0 }
            .bind(to: self.rootView.setSettingData)
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.inputType
            .compactMap { $0 }
            .bind(to: self.rootView.inputTypeView.segmentedControl.rx.selectedSegmentIndex)
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.baseHour
            .compactMap { $0 }
            .bind(to: self.rootView.hourView.hourLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
}
