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
    return self.map { time in
      let hour = (time / 60)
      let min = (time % 60)
      return String(format: "%02d:%02d", hour, min)
    }
  }
  
  func toRestHourMin() -> Observable<String> {
    return self.map { time in
      let hour = (time / 60)
      let min = (time % 60)
      return String(format: "%d시간 %02d분", hour, min)
    }
  }
}



extension ObservableType where Element == Int? {
  
  func toHourMin() -> Observable<String> {
    return self.map { time in
      guard let time = time else { return "-" }
      let hour = (time / 60)
      let min = (time % 60)
      return String(format: "%02d:%02d", hour, min)
    }
  }
  
  func toRestHourMin() -> Observable<String> {
    return self.map { time in
      guard let time = time else { return "-" }
      let hour = (time / 60)
      let min = (time % 60)
      return String(format: "%d시간 %02d분", hour, min)
    }
  }
}
