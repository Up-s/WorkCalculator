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
  
  var message: [NotionModel] = []
  var settingData: SettingModel?
  var blocks: [BlockModel] = []
  var refreshDate: Date?
  let refreshInterval = 30
  let maxDeviceCount = 3
}



extension AppManager {
  
  static var appstoreURL: String {
    "https://apps.apple.com/us/app/%EC%B9%BC%ED%87%B4-%EA%B3%84%EC%82%B0%EA%B8%B0/id1663166045"
  }
}
