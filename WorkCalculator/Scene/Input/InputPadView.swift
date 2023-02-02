//
//  InputPadView.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/02/02.
//

import UIKit

import SnapKit
import Then
import UPsKit

final class InputPadView: BaseView {
  
  // MARK: - Property
  
  private let contentsStackView = UPsStackView(axis: .vertical)
  let timerLabel = UILabel().then { view in
    view.textColor = .gray700
    view.textAlignment = .center
    view.font = .boldSystemFont(ofSize: 24.0)
  }
  let padCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .gray200
    collectionView.register(cellType: InputPadCollectionViewCell.self)
    return collectionView
  }()
  
  
  
  // MARK: - Life Cycle
  
  override init() {
    super.init()
    
    self.setAttribute()
    self.setConstraint()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  // MARK: - Interface
  
  
  
  // MARK: - UI
  
  private func setAttribute() {
    self.addSubview(self.contentsStackView)
    
    [self.timerLabel, self.padCollectionView]
      .forEach(self.contentsStackView.addArrangedSubview(_:))
  }
  
  private func setConstraint() {
    self.timerLabel.snp.makeConstraints { make in
      make.height.equalTo(48.0)
    }
  }
  
  private struct Metric {
    static let space: CGFloat = 2.0
  }
}



// MARK: - UICollectionViewDelegateFlowLayout

extension InputPadView: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    UIEdgeInsets(all: Metric.space)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    Metric.space
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    Metric.space
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width: CGFloat = floor((collectionView.bounds.width - (Metric.space * 4)) / 3)
    let height: CGFloat = floor((collectionView.bounds.height - (Metric.space * 5)) / 4)
    return CGSize(width: width, height: height)
  }
}

