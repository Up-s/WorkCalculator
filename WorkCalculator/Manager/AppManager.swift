//
//  AppManager.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/07.
//

import Foundation

final class AppManager {
    
    static let shared = AppManager()
    private init () {}
    
    var settingData: SettingModel?
    
}
