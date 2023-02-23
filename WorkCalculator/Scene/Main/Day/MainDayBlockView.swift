//
//  MainDayBlockView.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/02/23.
//

import UIKit

import SnapKit
import Then
import UPsKit

final class MainDayBlockView: UIView {
  
  // MARK: - Property
  
  let blockCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(cellType: MainDayBlockCollectionViewCell.self)
    return collectionView
  }()
  
  
  
  // MARK: - Life Cycle
  
  init() {
    super.init(frame: .zero)
    
    self.setAttribute()
    self.setConstraint()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  // MARK: - Interface
  
  
  
  // MARK: - UI
  
  private func setAttribute() {
    self.blockCollectionView.delegate = self
    
    
    
    self.addSubview(self.blockCollectionView)
  }
  
  private func setConstraint() {
    self.snp.makeConstraints { make in
      make.height.equalTo(320.0)
    }
    
    self.blockCollectionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private struct Metric {
    static let xInset: CGFloat = 24.0
    static let yInset: CGFloat = 24.0
    static let spacing: CGFloat = 12.0
    static let padding: CGFloat = 12.0
  }
}



extension MainDayBlockView: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    UIEdgeInsets(x: Metric.xInset, y: Metric.yInset)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    Metric.spacing
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    .zero
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.bounds.width - Metric.xInset - Metric.spacing - Metric.padding
    let height = collectionView.bounds.height - (Metric.yInset * 2)
    return CGSize(width: width, height: height)
  }
}
