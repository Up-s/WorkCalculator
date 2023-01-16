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
        self.rootView.navigationView.leftButton.rx.tap
            .bind(to: self.viewModel.base.backDidTap)
            .disposed(by: self.disposeBag)
        
        self.rx.viewDidAppear
            .bind(to: self.viewModel.input.viewDidAppear)
            .disposed(by: self.disposeBag)
        
        
        
        self.viewModel.output.blocks
            .bind(
                to: self.rootView.tableView.rx.items(
                    cellIdentifier: HistoryTableViewCell.identifier,
                    cellType: HistoryTableViewCell.self
                )
            ) { row, element, cell in
                cell.setData(element)
            }
            .disposed(by: self.disposeBag)
    }
}
