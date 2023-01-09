//
//  PickerViewController.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/05.
//

import UIKit

import RxCocoa
import RxSwift
import UPsKit

final class PickerViewController: BaseViewController {
    
    // MARK: - Property
    
    private let rootView = PickerView()
    private let viewModel: PickerViewModel
    
    
    
    // MARK: - Life Cycle
    
    init(_ viewModel: PickerViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        self.rx.viewDidAppear
            .compactMap { $0 }
            .withLatestFrom(self.viewModel.output.state)
            .filter { $0 == .start || $0 == .end }
            .bind { [weak self] _ in
                self?.rootView.setData()
            }
            .disposed(by: self.disposeBag)
        
        self.rootView.cancelButton.rx.tap
            .bind(to: self.viewModel.input.cancelDidTap)
            .disposed(by: self.disposeBag)
        
        self.rootView.okButton.rx.tap
            .map { [weak self] in
                let hour = self?.rootView.selectHour ?? 0
                let min = self?.rootView.selectMin ?? 0
                return (hour, min)
            }
            .bind(to: self.viewModel.input.okDidTap)
            .disposed(by: self.disposeBag)
        
        
        
        self.viewModel.output.title
            .bind(to: self.rootView.titleLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
}
