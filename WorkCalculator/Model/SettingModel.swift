//
//  SettingModel.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/06.
//

import Foundation

struct SettingModel: Codable {
    
    var workBaseHour: Int
    
    init(
        workBaseHour: Int = 40
    ) {
        self.workBaseHour = workBaseHour
    }
}
