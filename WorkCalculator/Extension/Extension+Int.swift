//
//  Extension+Int.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/16.
//

import Foundation

import RxSwift

extension ObservableType where Element == Int {
  
  func toHourMin() -> Observable<String> {
    return self.map { timer in
      let hour = (timer / 60)
      let min = (timer % 60)
      return String(format: "%02d:%02d", hour, min)
    }
  }
  
  func toRestHourMin() -> Observable<String> {
    return self.map { timer in
      let hour = (timer / 60)
      let min = (timer % 60)
      return String(format: "%d시간 %02d분", hour, min)
    }
  }
}
