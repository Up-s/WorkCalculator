//
//  InputPadCollectionViewCell.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/02/02.
//

import UIKit

import SnapKit
import Then
import UPsKit

final class InputPadCollectionViewCell: UICollectionViewCell, CellIdentifiable {
  
  // MARK: - Property
  
  private let titleLabel = UILabel().then { view in
    view.backgroundColor = .light
    view.textColor = .gray900
    view.textAlignment = .center
    view.font = .boldSystemFont(ofSize: 20.0)
  }
  
  
  
  // MARK: - Life Cycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.setAttribute()
    self.setConstraint()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  // MARK: - Interface
  
  func setData(_ data: String) {
    self.titleLabel.text = data
  }
  
  
  
  // MARK: - UI
  
  private func setAttribute() {
    self.contentView.addSubview(self.titleLabel)
  }
  
  private func setConstraint() {
    self.titleLabel.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}
