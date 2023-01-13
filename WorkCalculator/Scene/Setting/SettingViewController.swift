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
        self.rootView.navigationView.leftButton.rx.tap
            .bind(to: self.viewModel.base.backDidTap)
            .disposed(by: self.disposeBag)
        
        self.rootView.idView.copyButton.rx.tap
            .bind(to: self.viewModel.input.copyDidTap)
            .disposed(by: self.disposeBag)
        
        self.rootView.idView.shareButton.rx.tap
            .bind(to: self.viewModel.input.shareDidTap)
            .disposed(by: self.disposeBag)
        
        self.rootView.idView.shareCancelButton.rx.tap
            .bind(to: self.viewModel.input.shareCancelDidTap)
            .disposed(by: self.disposeBag)
        
        self.rootView.daysView.daysTableView.rx.modelSelected(DateManager.Day.self)
            .bind(to: self.viewModel.input.selectDay)
            .disposed(by: self.disposeBag)
        
        self.rootView.hourView.hourSlider.rx.value
            .skip(1)
            .map { Int($0) }
            .bind(to: self.viewModel.input.baseHour)
            .disposed(by: self.disposeBag)
        
        self.rootView.inputTypeView.segmentedControl.rx.selectedSegmentIndex
            .filter { $0 != -1 }
            .bind(to: self.viewModel.input.inputType)
            .disposed(by: self.disposeBag)
        
        self.rootView.saveButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind(to: self.viewModel.input.saveDidTap)
            .disposed(by: self.disposeBag)
        
        
        
        self.viewModel.output.selectDays
            .map { _ in }
            .bind(to: self.rootView.daysView.daysTableView.rx.reload)
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.allDays
            .bind(to: self.rootView.daysView.daysTableView.rx.items) { [weak self] (tableView: UITableView, index: Int, element: DateManager.Day) -> UITableViewCell in
                guard
                    let self = self,
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
                else { return UITableViewCell() }
                
                cell.backgroundColor = .clear
                cell.textLabel?.text = element.ko
                cell.selectionStyle = .none
                
                let isSelect = self.viewModel.output.selectDays.value.contains(element)
                cell.accessoryType = isSelect ? .checkmark : .none
                
                return cell
            }
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.baseHour
            .compactMap { $0 }
            .bind(to: self.rootView.hourView.hourLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.inputType
            .compactMap { $0 }
            .bind(to: self.rootView.inputTypeView.segmentedControl.rx.selectedSegmentIndex)
            .disposed(by: self.disposeBag)
        
    }
}
