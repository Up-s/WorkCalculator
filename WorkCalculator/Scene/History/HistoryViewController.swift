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
    
    self.rootView.dayCollectionView.rx.willDisplayCell
      .map { $1.item }
      .bind(to: self.viewModel.input.willCellIndex)
      .disposed(by: self.disposeBag)
    
    self.rootView.dayCollectionView.rx.itemSelected
      .map { $0.item }
      .bind(to: self.viewModel.input.selectIndex)
      .disposed(by: self.disposeBag)
    
    self.rootView.dayCollectionView.rx.itemSelected
      .map { _ in }
      .bind(to: self.rootView.dayCollectionView.rx.reload)
      .disposed(by: self.disposeBag)
    
    
    
    self.viewModel.output.title
      .distinctUntilChanged()
      .bind(to: self.rootView.titleLabel.rx.text)
      .disposed(by: self.disposeBag)
    
    self.viewModel.output.blocks
      .bind(
        to: self.rootView.dayCollectionView.rx.items(
          cellIdentifier: HistoryCollectionViewCell.identifier,
          cellType: HistoryCollectionViewCell.self
        )
      ) { [weak self] row, element, cell in
        cell.setData(element)
        
        let selectIndex = self?.viewModel.input.selectIndex.value ?? 0
        let state = selectIndex == row
        cell.setBorder(state)
      }
      .disposed(by: self.disposeBag)
    
    self.viewModel.output.selectBlock
      .compactMap { $0 }
      .distinctUntilChanged()
      .bind { [weak self] block in
        self?.rootView.setData(block)
      }
      .disposed(by: self.disposeBag)
  }
}
