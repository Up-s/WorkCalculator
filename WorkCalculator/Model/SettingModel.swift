//
//  SettingModel.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/06.
//

import Foundation

struct SettingModel: Codable {
    
    let createDate: Date
    let latestBlockDate: Date
    var days: [DateManager.Day]
    var workBaseHour: Int
    var inputType: Int
    
    init() {
        self.createDate =  Date()
        self.latestBlockDate =  Date()
        self.days = [.mon, .tue, .wed, .thu, .fri]
        self.workBaseHour = 40
        self.inputType = 0
    }
}
