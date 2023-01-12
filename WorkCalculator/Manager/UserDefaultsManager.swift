//
//  UserDefaultsManager.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/06.
//

import Foundation

final class UserDefaultsManager {
    
    enum Key: String, CaseIterable {
        case firebaseID
    }
    
    private static let userDefault = UserDefaults.standard
    
    
    
    static var firebaseID: String? {
        get { self.userDefault.string(forKey: Key.firebaseID.rawValue) }
        set { self.userDefault.set(newValue, forKey: Key.firebaseID.rawValue) }
    }
}
