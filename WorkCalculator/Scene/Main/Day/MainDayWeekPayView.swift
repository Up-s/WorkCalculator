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

final class MainDayWeekPayView: BaseView {
  
  // MARK: - Property
  
  let weekPayButton = UIButton().then { view in
    view.setTitleColor(.gray800, for: .normal)
    view.titleLabel?.font = .boldSystemFont(ofSize: 24.0)
    view.backgroundColor = .gray200
    view.layer.cornerRadius = 8.0
    view.layer.masksToBounds = true
  }
  
  
  
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
    self.addSubview(self.weekPayButton)
  }
  
  private func setConstraint() {
    self.weekPayButton.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(24.0)
    }
  }
}
