//
//  UpdateViewController.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/11.
//

import UIKit

import RxCocoa
import RxSwift
import UPsKit

final class UpdateViewController: BaseViewController {
    
    // MARK: - Property
    
    private let rootView = UpdateView()
    private let viewModel: UpdateViewModel
    
    
    
    // MARK: - Life Cycle
    
    init(_ viewModel: UpdateViewModel) {
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
            .bind(to: self.viewModel.input.viewDidAppear)
            .disposed(by: self.disposeBag)
        
        
        
        self.viewModel.output.progress
            .bind { [weak self] progress in
                self?.rootView.setProgress(progress)
            }
            .disposed(by: self.disposeBag)
    }
}
