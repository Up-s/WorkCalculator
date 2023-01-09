//
//  SettingModel.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/06.
//

import Foundation

struct SettingModel: Codable {
    
    var days: [DateManager.Day]
    var workBaseHour: Int
    
    init(
        days: [DateManager.Day],
        workBaseHour: Int = 40
    ) {
        self.days = days
        self.workBaseHour = workBaseHour
    }
}
