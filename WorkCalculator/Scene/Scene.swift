//
//  Scene.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/05.
//

import UIKit
import UPsKit

enum Scene: SceneProtocol {
  
  case splash
  case main(MainViewModel)
  case clock(ClockViewModel)
  case picker(PickerViewModel)
  case numberPad(NumberPadViewModel)
  case history
  case setting
  case update(UpdateViewModel)
  
  
  
  var target: UIViewController {
    switch self {
    case .splash:
      return SplashViewController()
      
    case .main(let viewModel):
      return MainViewController(viewModel)
      
    case .clock(let viewModel):
      return ClockViewController(viewModel)
      
    case .picker(let viewModel):
      return PickerViewController(viewModel)
      
    case .numberPad(let viewModel):
      return NumberPadViewController(viewModel)
      
    case .history:
      return HistoryViewController()
      
    case .setting:
      return SettingViewController()
      
    case .update(let viewModel):
      return UpdateViewController(viewModel)
    }
  }
}
