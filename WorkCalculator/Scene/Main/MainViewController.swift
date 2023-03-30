//
//  MainViewController.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/05.
//

import UIKit

import RxCocoa
import RxSwift
import UPsKit

final class MainViewController: BaseViewController {
  
  // MARK: - Property
  
  private let rootView: MainViewProtocol
  private let viewModel: MainViewModel
  
  
  
  // MARK: - Life Cycle
  
  init(_ viewModel: MainViewModel) {
    self.viewModel = viewModel
    self.rootView = viewModel.mainView
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
    self.rootView.changeViewButton.rx.tap
      .bind(to: self.viewModel.input.changeViewDidTap)
      .disposed(by: self.disposeBag)
    
    self.rootView.refreshButton.rx.tap
      .bind(to: self.viewModel.input.refreshDidTap)
      .disposed(by: self.disposeBag)
    
    self.rootView.histortButton.rx.tap
      .bind(to: self.viewModel.input.historyDidTap)
      .disposed(by: self.disposeBag)
    
    self.rootView.settingButton.rx.tap
      .bind(to: self.viewModel.input.settingDidTap)
      .disposed(by: self.disposeBag)
    
    self.rootView.weekPayTouchDown?
      .bind(to: self.viewModel.input.weekPayTouchDown)
      .disposed(by: self.disposeBag)
    
    self.rootView.weekPayTouchOut?
      .bind(to: self.viewModel.input.weekPayTouchOut)
      .disposed(by: self.disposeBag)
    
    
    
    self.viewModel.output.blockViewModels
      .bind(to: self.rootView.blockViewModels)
      .disposed(by: self.disposeBag)
    
    self.viewModel.output.sumRunTime
      .bind(to: self.rootView.runTime)
      .disposed(by: self.disposeBag)
    
    self.viewModel.output.notionData
      .bind(to: self.rootView.notionData)
      .disposed(by: self.disposeBag)
    
    self.viewModel.output.weekPay
      .compactMap { $0 }
      .bind(to: self.rootView.weekPay)
      .disposed(by: self.disposeBag)
  }
}
