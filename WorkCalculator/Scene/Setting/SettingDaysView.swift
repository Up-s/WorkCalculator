//
//  SettingDaysView.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/09.
//

import UIKit

import SnapKit
import Then
import UPsKit

final class SettingDaysView: UIView {
  
  // MARK: - Property
  
  private let contentsStackView = UPsStackView(axis: .vertical, spacing: 8.0)
  private let titleLabel = SettingInfoLabel().then { view in
    view.text = "근무일"
  }
  let daysTableView = UITableView().then { view in
    view.backgroundColor = .gray200
    view.rowHeight = Metric.rowHeight
    view.separatorStyle = .none
    view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
    
    [self.titleLabel, self.daysTableView]
      .forEach(self.contentsStackView.addArrangedSubview(_:))
  }
  
  private func setConstraint() {
    self.contentsStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    self.daysTableView.snp.makeConstraints { make in
      make.height.equalTo(Metric.rowHeight * 7)
    }
  }
  
  private struct Metric {
    static let rowHeight: CGFloat = 48.0
  }
}
