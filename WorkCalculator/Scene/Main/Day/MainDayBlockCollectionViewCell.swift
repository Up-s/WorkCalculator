//
//  MainDayBlockCollectionViewCell.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/02/23.
//

import UIKit

import SnapKit
import Then
import UPsKit

final class MainDayBlockCollectionViewCell: UICollectionViewCell, CellIdentifiable {
  
  // MARK: - Property
  
  private let dayLabel = UILabel().then { view in
    view.backgroundColor = .gray200
    view.textAlignment = .center
    view.textColor = .gray900
    view.font = .boldSystemFont(ofSize: 20.0)
  }
  let startButton = UIButton()
  let endButton = UIButton()
  let restButton = UIButton()
  let runTimeInfoLabel = UILabel().then { view in
    view.text = "일일근무시간"
    view.textColor = .gray900
    view.font = .systemFont(ofSize: 16.0)
  }
  let runTimeLabel = UILabel().then { view in
    view.textColor = .gray900
    view.font = .boldSystemFont(ofSize: 16.0)
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
  
  func setData(_ data:  MainBlockViewModel) {
    
  }
  
  
  
  // MARK: - UI
  
  private func setAttribute() {
    self.contentView.backgroundColor = .gray200
    self.contentView.layer.cornerRadius = 4.0
    self.contentView.layer.masksToBounds = true
  }
  
  private func setConstraint() {
    
  }
}
