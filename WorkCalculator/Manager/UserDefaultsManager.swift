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
        case inputType
        
        case sunStartTimeBlock
        case sunEndTimeBlock
        case sunRestTimeBlock
        
        case monStartTimeBlock
        case monEndTimeBlock
        case monRestTimeBlock
        
        case tueStartTimeBlock
        case tueEndTimeBlock
        case tueRestTimeBlock
        
        case wedStartTimeBlock
        case wedEndTimeBlock
        case wedRestTimeBlock
        
        case thuStartTimeBlock
        case thuEndTimeBlock
        case thuRestTimeBlock
        
        case friStartTimeBlock
        case friEndTimeBlock
        case friRestTimeBlock
        
        case satStartTimeBlock
        case satEndTimeBlock
        case satRestTimeBlock
    }
    
    private static let userDefault = UserDefaults.standard
    
    class func resetTimeBlock() {
        Key.allCases
            .filter { $0 != .firebaseID || $0 != .inputType }
            .forEach {
                self.userDefault.removeObject(forKey: $0.rawValue)
            }
    }
    
    
    
    
    
    static var firebaseID: String? {
        get { self.userDefault.string(forKey: Key.firebaseID.rawValue) }
        set { self.userDefault.set(newValue, forKey: Key.firebaseID.rawValue) }
    }
    
    static var inputType: Int {
        get { self.userDefault.integer(forKey: Key.inputType.rawValue) }
        set { self.userDefault.set(newValue, forKey: Key.inputType.rawValue) }
    }
    
}
