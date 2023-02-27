//
//  TimeButtonView.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/02/27.
//

import UIKit

import SnapKit
import Then
import UPsKit

final class TimeButtonView: UIView {
  
  // MARK: - Property
  
  private let contentsStackView = UPsStackView(axis: .horizontal, alignment: .center, distribution: .fillProportionally, spacing: 4.0).then { view in
    view.layer.cornerRadius = 8.0
    view.layer.masksToBounds = true
    view.backgroundColor = .gray300
  }
  private let titleLabel = UILabel()
  private let lineView = UIView().then { view in
    view.backgroundColor = .gray900
  }
  let timeLabel = UILabel().then { view in
    view.text = "00:00"
  }
  let button = UIButton()
  
  
  
  // MARK: - Life Cycle
  
  init(_ state: DateManager.State) {
    super.init(frame: .zero)
    
    self.titleLabel.text = state.ko
    
    self.setAttribute()
    self.setConstraint()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  // MARK: - Interface
  
  
  
  // MARK: - UI
  
  private func setAttribute() {
    [self.titleLabel, self.timeLabel].forEach { view in
      view.textAlignment = .center
      view.textColor = .gray800
      view.font = .systemFont(ofSize: 18.0, weight: .bold)
    }
    
    
    
    [self.contentsStackView, self.button]
      .forEach(self.addSubview(_:))
    
    [self.titleLabel, self.lineView, self.timeLabel]
      .forEach(self.contentsStackView.addArrangedSubview(_:))
  }
  
  private func setConstraint() {
    self.contentsStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.width.equalTo(180.0)
      make.height.equalTo(40.0)
    }
    
    self.button.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    self.titleLabel.snp.makeConstraints { make in
      make.width.equalTo(64.0)
    }
    
    self.lineView.snp.makeConstraints { make in
      make.width.equalTo(1.0)
      make.height.equalTo(16.0)
    }
  }
}
