//
//  HistoryTimeBlockView.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/14.
//

import UIKit

import SnapKit
import Then
import UPsKit

final class HistoryTimeBlockView: UIView {
  
  // MARK: - Property
  
  private let contentsStackView = UPsStackView(axis: .vertical, spacing: 8.0)
  let titleLabel = UILabel().then { view in
    view.textAlignment = .center
    view.textColor = .gray900
    view.font = .boldSystemFont(ofSize: 15.0)
    view.backgroundColor = .gray100
  }
  let timeLabel = UILabel().then { view in
    view.textAlignment = .center
    view.textColor = .gray900
    view.font = .boldSystemFont(ofSize: 25.0)
    view.backgroundColor = .gray200
  }
  
  
  
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
    self.addSubview(self.contentsStackView)
    
    [self.titleLabel, self.timeLabel]
      .forEach(self.contentsStackView.addArrangedSubview(_:))
  }
  
  private func setConstraint() {
    self.contentsStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    self.titleLabel.snp.makeConstraints { make in
      make.height.equalTo(24.0)
    }
    
    self.timeLabel.snp.makeConstraints { make in
      make.height.equalTo(56.0)
    }
  }
}
