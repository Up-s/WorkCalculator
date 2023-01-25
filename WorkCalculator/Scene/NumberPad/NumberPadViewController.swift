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
  private let viewModel: NumberPadViewModel
  
  
  
  // MARK: - Life Cycle
  
  init(_ viewModel: NumberPadViewModel) {
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
    self.rootView.inputButtonView.cancelButton.rx.tap
      .bind(to: self.viewModel.input.cancelDidTap)
      .disposed(by: self.disposeBag)
    
    self.rootView.inputButtonView.okButton.rx.tap
      .bind(to: self.viewModel.input.okDidTap)
      .disposed(by: self.disposeBag)
    
    self.rootView.padCollectionView.rx.itemSelected
      .map { $0.row }
      .bind(to: self.viewModel.input.inputNumber)
      .disposed(by: self.disposeBag)
    
    
    
    self.viewModel.output.title
      .bind(to: self.rootView.titleLabel.rx.text)
      .disposed(by: self.disposeBag)
    
    self.viewModel.output.timer
      .bind(to: self.rootView.timerLabel.rx.text)
      .disposed(by: self.disposeBag)
    
    self.viewModel.output.numberPadList
      .bind(
        to: self.rootView.padCollectionView.rx.items(
          cellIdentifier: NumberPadCollectionViewCell.identifier,
          cellType: NumberPadCollectionViewCell.self
        )
      ) { row, element, cell in
        cell.setData(element)
      }
      .disposed(by: self.disposeBag)
  }
}
