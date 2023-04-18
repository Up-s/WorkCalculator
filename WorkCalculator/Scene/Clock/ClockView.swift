//
//  ClockView.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/04/18.
//

import UIKit

import SnapKit
import Then
import UPsKit

final class ClockView: BaseView, NavigationProtocol {
  
  // MARK: - Property
  
  let navigationView: BaseNavigationView = BaseNavigationView(.dismiss)
  
  
  
  // MARK: - Life Cycle
  
  override init() {
    super.init()
    
    self.setNavigation()
    self.setAttribute()
    self.setConstraint()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  // MARK: - Interface
  
  
  
  // MARK: - UI
  
  private func setAttribute() {
    
  }
  
  private func setConstraint() {
    
  }
}
