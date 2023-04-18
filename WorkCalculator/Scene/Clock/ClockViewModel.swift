//
//  ClockViewModel.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/04/18.
//

import Foundation

import RxCocoa
import RxSwift
import UPsKit

final class ClockViewModel: BaseViewModel {
  
  struct Input {
  }
  
  struct Output {
  }
  
  // MARK: - Property
  
  let input = Input()
  let output = Output()
  
  
  
  
  // MARK: - Interface
  
  init() {
    super.init()
    
  }
}
