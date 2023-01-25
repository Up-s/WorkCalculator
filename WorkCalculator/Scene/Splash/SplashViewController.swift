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
import UIKit

final class SplashViewController: BaseViewController {
  
  // MARK: - Property
  
  private let rootView = SplashView()
  private let viewModel = SplashViewModel()
  
  
  
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
    self.rx.viewDidAppear
      .bind(to: self.viewModel.input.viewDidAppear)
      .disposed(by: self.disposeBag)
  }
}
