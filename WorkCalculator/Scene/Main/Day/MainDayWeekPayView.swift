//
//  MainDayWeekPayView.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/03/06.
//

import UIKit

import SnapKit
import Then
import UPsKit

final class MainDayWeekPayView: UIView {
  
  // MARK: - Property
  
  let weekPayButton = UIButton().then { view in
    let title = "💰"
    view.setTitle(title, for: .normal)
    view.setTitleColor(.gray800, for: .normal)
    view.titleLabel?.font = .boldSystemFont(ofSize: 24.0)
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
    self.addSubview(self.weekPayButton)
  }
  
  private func setConstraint() {
    self.weekPayButton.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(24.0)
    }
  }
}
