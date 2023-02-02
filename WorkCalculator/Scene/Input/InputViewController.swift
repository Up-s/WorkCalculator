//
//  InputViewController.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/02/02.
//

import UIKit

import RxCocoa
import RxSwift
import UPsKit

final class InputViewController: BaseViewController {
  
  // MARK: - Property
  
  private let rootView = InputView()
  private let viewModel: InputViewModel
  
  
  
  // MARK: - Life Cycle
  
  init(_ viewModel: InputViewModel) {
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
    self.rootView.pickerView.pickerView.rx.itemSelected
      .bind {
        print("\n--------------------------------------------", $0.row, $0.component)
      }
      .disposed(by: self.disposeBag)
    
    self.rootView.padView.padCollectionView.rx.itemSelected
      .map { $0.row }
      .bind(to: self.viewModel.input.inputPad)
      .disposed(by: self.disposeBag)
    
    
    self.rootView.buttonView.cancelButton.rx.tap
      .bind(to: self.viewModel.input.cancelDidTap)
      .disposed(by: self.disposeBag)
    
    self.rootView.buttonView.okButton.rx.tap
      .bind(to: self.viewModel.input.okDidTap)
      .disposed(by: self.disposeBag)
    
    
    
    self.viewModel.output.time
      .bind { [weak self] in
        self?.rootView.pickerView.setData($0)
      }
      .disposed(by: self.disposeBag)
    
    self.viewModel.output.time
      .map { String($0) }
      .map { $0.numberPattern(pattern: .hourMin) }
      .bind(to: self.rootView.padView.timerLabel.rx.text)
      .disposed(by: self.disposeBag)
  }
}
