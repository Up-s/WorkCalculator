//
//  NumberPadViewController.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/08.
//

import UIKit

import RxCocoa
import RxSwift
import UPsKit

final class NumberPadViewController: BaseViewController {
    
    // MARK: - Property
    
    private let rootView = NumberPadView()
    private let viewModel = NumberPadViewModel()
    
    
    
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
        
    }
}
