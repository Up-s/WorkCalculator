//
//  InputType.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/07.
//

import Foundation

enum InputType: Int, CaseIterable {
  
  case sliderPicker = 0
  case numberPad
  
  var title: String {
    switch self {
    case .sliderPicker: return "슬라이더"
    case .numberPad: return "키패드"
    }
  }
}
