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
    var blocks: [BlockModel] = []
    var refreshDate: Date?
    let refreshInterval = 30
    let maxDeviceCount = 3
}
