//
//  ClockViewController.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/04/18.
//

import UIKit

import RxCocoa
import RxSwift
import UPsKit

final class ClockViewController: BaseViewController {
  
  // MARK: - Property
  
  private let rootView = ClockView()
  private let viewModel: ClockViewModel
  
  
  
  // MARK: - Life Cycle
  
  init(_ viewModel: ClockViewModel) {
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
    self.rootView.navigationView.leftButton.rx.tap
      .bind(to: self.viewModel.base.dismissDidTap)
      .disposed(by: self.disposeBag)
    
    
  }
}
