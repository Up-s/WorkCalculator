//
//  SplashViewController.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/05.
//

import UIKit

import RxCocoa
import RxSwift
import UPsKit

final class SplashViewController: BaseViewController {
    
    // MARK: - Property
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configure()
        self.bindViewModel()
    }
    
    
    
    // MARK: - Interface
    
    private func configure() {
        self.view.backgroundColor = .blue
    }
    
    private func bindViewModel() {
        
    }
}
