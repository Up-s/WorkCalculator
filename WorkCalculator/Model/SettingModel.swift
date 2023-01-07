//
//  SettingModel.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/06.
//

import Foundation

struct SettingModel: Codable {
    
    var weeks: [Int]
    var workBaseHour: Int
    
    init(
        weeks: [Int] = [2, 3, 4, 5, 6],
        workBaseHour: Int = 40
    ) {
        self.weeks = weeks
        self.workBaseHour = workBaseHour
    }
}
