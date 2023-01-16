//
//  RealmBlockModel.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/16.
//

import Foundation

import RealmSwift

class RealmBlockModel: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var weekInfo: String = ""
    @Persisted var weekdayType: Int = 0
    @Persisted var year: Int = 0
    @Persisted var month: Int = 0
    @Persisted var day: Int = 0
    @Persisted var startTime: Int = 0
    @Persisted var endTime: Int = 0
    @Persisted var restTime: Int = 0
    
    convenience init(_ block: BlockModel) {
        self.init()
        self.weekInfo = block.weekInfo
        self.weekdayType = block.weekday.weekdayInt
        self.year = block.year
        self.month = block.month
        self.day = block.day
        self.startTime = block.startTime
        self.endTime = block.endTime
        self.restTime = block.restTime
    }
    
    
    var weekday: DateManager.Day {
        get { DateManager.Day(self.weekdayType) }
        set { self.weekdayType = newValue.weekdayInt }
    }
}
