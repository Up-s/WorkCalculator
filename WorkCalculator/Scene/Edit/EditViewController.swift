//
//  EditViewController.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/05.
//

import UIKit

import RxCocoa
import RxSwift
import UPsKit

final class EditViewController: BaseViewController {
    
    // MARK: - Property
    
    private let rootView = EditView()
    private let viewModel = EditViewModel()
    
    
    
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
        Observable.just(self.rootView.timeBlockViewModels)
            .bind(to: self.viewModel.input.timeBlockViewModels)
            .disposed(by: self.disposeBag)
        
        self.rootView.resetButton.rx.tap
            .bind(to: self.viewModel.input.resetDidTap)
            .disposed(by: self.disposeBag)
        
        self.rootView.settingButton.rx.tap
            .bind(to: self.viewModel.input.settingDidTap)
            .disposed(by: self.disposeBag)
        
        
        
        self.viewModel.output.sumRunTime
            .bind { [weak self] in
                self?.rootView.setData($0)
            }
            .disposed(by: self.disposeBag)
    }
}
