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
    var inputType: Int
    
    init(
        days: [DateManager.Day] = [.mon, .tue, .wed, .thu, .fri],
        workBaseHour: Int = 40,
        inputType: Int = 0
    ) {
        self.days = days
        self.workBaseHour = workBaseHour
        self.inputType = inputType
    }
}
