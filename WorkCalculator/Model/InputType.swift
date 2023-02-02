//
//  InputType.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/07.
//

import Foundation

enum InputType: Int, CaseIterable {
  
  case picker = 0
  case pad
  case slider
  
  var title: String {
    switch self {
    case .picker: return "Picker"
    case .pad: return "Pad"
    case .slider: return "Slider"
    }
  }
}
