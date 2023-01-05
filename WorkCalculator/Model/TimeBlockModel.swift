//
//  TimeBlockModel.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/05.
//

import Foundation

struct TimeBlockModel {
    
    var date: Date?
    let day: DateManager.Day
    let state: DateManager.State
    var hour: Int
    var min: Int
    
}


extension TimeBlockModel {
    
    var interval: Int {
        (hour * 60) + min
    }
    
    var intervalString: String {
        String(format: "%d:%02d", self.hour, self.min)
    }
}
