//
//  DayBlockModel.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/14.
//

import Foundation

struct DayBlockModel {
    
    let startTimeBlock: TimeBlockModel
    let endTimeBlock: TimeBlockModel
    let restTimeBlock: TimeBlockModel
    
    init(timeBlocks: [TimeBlockModel]) {
        self.startTimeBlock = timeBlocks[0]
        self.endTimeBlock = timeBlocks[1]
        self.restTimeBlock = timeBlocks[2]
    }
    
    var interval: Int {
        let startInterval = self.startTimeBlock.interval
        let endInterval = self.endTimeBlock.interval
        let restInterval = self.restTimeBlock.interval
        return startInterval - endInterval - restInterval
    }
    
    var intervalString: String {
        let hour = self.interval / 60
        let min = self.interval % 60
        return String(format: "%d시간 %02d분", hour, min)
    }
    
    var info: String {
        "\(self.startTimeBlock.month)월 \(self.startTimeBlock.day)일 (\(self.startTimeBlock.weekday.ko))       근무시간 - \(self.intervalString)"
    }
}
