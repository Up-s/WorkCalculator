//
//  SettingInfoLabel.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/07.
//

import UIKit

import UPsKit

final class SettingInfoLabel: UILabel {
  
  init() {
    super.init(frame: .zero)
    
    self.textColor = .gray900
    self.font = .boldSystemFont(ofSize: 15.0)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
