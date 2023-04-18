//
//  MainViewUIComponents.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/04/18.
//

import UIKit

struct MainViewUIComponents {
  
  static var clockViewButton: UIButton {
    let button = UIButton()
    let image = UIImage.sfConfiguration(name: "clock", color: .systemBlue)
    button.setImage(image, for: .normal)
    return button
  }
  
  static var changeViewButton: UIButton {
    let button = UIButton()
    let image = UIImage.sfConfiguration(name: "rectangle.portrait.on.rectangle.portrait", color: .systemBlue)
    button.setImage(image, for: .normal)
    return button
  }
  
  static var refreshButton: UIButton {
    let button = UIButton()
    let image = UIImage.sfConfiguration(name: "icloud.and.arrow.down", color: .systemBlue)
    button.setImage(image, for: .normal)
    return button
  }
  
  static var histortButton: UIButton {
    let button = UIButton()
    let image = UIImage.sfConfiguration(name: "rectangle.stack", color: .systemBlue)
    button.setImage(image, for: .normal)
    return button
  }
  
  static var settingButton: UIButton {
    let button = UIButton()
    let image = UIImage.sfConfiguration(name: "gearshape", color: .systemBlue)
    button.setImage(image, for: .normal)
    return button
  }
  
}
