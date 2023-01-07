//
//  SettingModel.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/06.
//

import Foundation

struct SettingModel: Codable {
    
    var days: [Int]
    var workBaseHour: Int
    
    init(
        days: [Int] = [2, 3, 4, 5, 6],
        workBaseHour: Int = 40
    ) {
        self.days = days
        self.workBaseHour = workBaseHour
    }
}
