//
//  SettingWeekPayView.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/03/09.
//

import UIKit

import SnapKit
import Then
import UPsKit

final class SettingWeekPayView: UIView {
  
  // MARK: - Property
  
  private let contentsStackView = UPsStackView(axis: .vertical, spacing: 8.0)
  private let titleLabel = SettingInfoLabel().then { view in
    view.text = "행복 계산기"
  }
  let inputButton = UIButton().then { view in
    view.setTitle("시급 입력하기", for: .normal)
    view.setTitleColor(.gray900, for: .normal)
    view.titleLabel?.font = .boldSystemFont(ofSize: 20.0)
    view.backgroundColor = .gray200
    view.layer.cornerRadius = 8.0
    view.layer.masksToBounds = true
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
    
    [self.titleLabel, self.inputButton]
      .forEach(self.contentsStackView.addArrangedSubview(_:))
  }
  
  private func setConstraint() {
    self.contentsStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    self.inputButton.snp.makeConstraints { make in
      make.height.equalTo(48.0)
    }
  }
}
