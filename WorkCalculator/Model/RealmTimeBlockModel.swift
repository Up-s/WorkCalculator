//
//  RealmTimeBlockModel.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/13.
//

import Foundation

import RealmSwift

class RealmTimeBlockModel: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var stateType: Int = 0
    @Persisted var weekdayType: Int = 0
    @Persisted var year: Int = 0
    @Persisted var month: Int = 0
    @Persisted var day: Int = 0
    @Persisted var hour: Int = 0
    @Persisted var min: Int = 0
    
    @Persisted var groupKey: String = ""
    
    convenience init(_ block: TimeBlockModel
    ) {
        self.init()
        self.stateType = block.state.index
        self.weekdayType = block.weekday.weekdayInt
        self.year = block.year
        self.month = block.month
        self.day = block.day
        self.hour = block.hour
        self.min = block.min
        
        self.groupKey = block.groupKey
    }
    
    
    
    var state: DateManager.State {
        get { DateManager.State(self.stateType) }
        set { self.stateType = newValue.index }
    }
    
    var weekday: DateManager.Day {
        get { DateManager.Day(self.weekdayType) }
        set { self.weekdayType = newValue.weekdayInt }
    }
    
}
