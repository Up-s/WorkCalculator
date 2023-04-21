//
//  UserDefaultsManager.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/06.
//

import Foundation

final class UserDefaultsManager {
  
  private enum Key: String, CaseIterable {
    case deviceUUID
    case firebaseID
    case mainType
    case hourlyWage
  }
  
  private static let userDefault = UserDefaults.standard
  
  
  
  static var deviceUUID: String? {
    get { self.userDefault.string(forKey: Key.deviceUUID.rawValue) }
    set { self.userDefault.set(newValue, forKey: Key.deviceUUID.rawValue) }
  }
  
  static var firebaseID: String? {
    get { self.userDefault.string(forKey: Key.firebaseID.rawValue) }
    set { self.userDefault.set(newValue, forKey: Key.firebaseID.rawValue) }
  }
  
  static var mainType: MainViewType {
    get {
      guard
        let string = self.userDefault.string(forKey: Key.mainType.rawValue),
        let type = MainViewType(rawValue: string)
      else {
        return .day
      }
      return type
    }
    set { self.userDefault.set(newValue.rawValue, forKey: Key.mainType.rawValue) }
  }
  
  static var hourlyWage: Int? {
    get { self.userDefault.object(forKey: Key.hourlyWage.rawValue) as? Int }
    set { self.userDefault.set(newValue, forKey: Key.hourlyWage.rawValue) }
  }
}
