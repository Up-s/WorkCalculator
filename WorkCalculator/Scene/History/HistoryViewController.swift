//
//  HistoryViewController.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/13.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift
import UPsKit

final class HistoryViewController: BaseViewController {
    
    // MARK: - Property
    
    private let rootView = HistoryView()
    private let viewModel = HistoryViewModel()
    
    
    
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
        
        self.rx.viewDidAppear
            .bind(to: self.viewModel.input.viewDidAppear)
            .disposed(by: self.disposeBag)
        
    }
}
