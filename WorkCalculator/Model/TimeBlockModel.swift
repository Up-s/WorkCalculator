//
//  TimeBlockModel.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/05.
//

import Foundation

struct TimeBlockModel: Codable {
    
    let deviceList: [String]
    
    let state: DateManager.State
    let weekday: DateManager.Day
    let year: Int
    let month: Int
    let day: Int
    var hour: Int
    var min: Int
    
    let groupKey: String
    
    init(
        state: DateManager.State,
        weekday: DateManager.Day,
        year: Int,
        month: Int,
        day: Int,
        hour: Int,
        min: Int
    ) {
        self.deviceList = []
        
        self.state = state
        self.weekday = weekday
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.min = min
        
        self.groupKey = "\(year)_\(month)_\(day)"
    }
    
    init(_ realm: RealmTimeBlockModel) {
        self.deviceList = []
        
        self.state = realm.state
        self.weekday = realm.weekday
        self.year = realm.year
        self.month = realm.month
        self.day = realm.day
        self.hour = realm.hour
        self.min = realm.min
        
        self.groupKey = realm.groupKey
    }
}



extension TimeBlockModel {
    
    var interval: Int {
        (self.hour * 60) + self.min
    }
    
    var intervalString: String {
        String(format: "%02d:%02d", self.hour, self.min)
    }
    
    var info: String {
        self.weekday.ko + "요일 " + self.state.ko
    }
    
    var monthDay: String {
        "\(self.month)월 \(self.day)일"
    }
    
    var firebaseKey: String {
        "\(self.year)_\(self.month)_\(self.day)_\(self.state.en)"
    }
    
    var date: Date {
        let dateComponents = DateComponents(year: self.year, month: self.month, day: self.day, hour: 0, minute: 0)
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        return calendar.date(from: dateComponents) ?? Date()
    }
    
    static var create: [TimeBlockModel] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        
//        let testDateComp = DateComponents(year: 2023, month: 1, day: 6)
//        let testDate = calendar.date(from: testDateComp)!
        
//        let testDateComp = DateComponents(year: 2022, month: 12, day: 30)
//        let testDate = calendar.date(from: testDateComp)!
        
        let today = Date()
        let weekday = today.weekdayInt()
        let blocks = DateManager.Day.allCases
            .map { inDay -> Date in
                let tempWeekday = inDay.weekdayInt - weekday
                let tempTimeInterval = TimeInterval(tempWeekday * 24 * 60 * 60)
                let tempDay = today + tempTimeInterval
                return tempDay
            }
            .flatMap { inDate -> [TimeBlockModel] in
                let inBlocks = DateManager.State.allCases
                    .map { inState -> TimeBlockModel in
                        return TimeBlockModel(
                            state: inState,
                            weekday: DateManager.Day(inDate.weekdayInt()),
                            year: inDate.yearInt(),
                            month: inDate.monthInt(),
                            day: inDate.dayInt(),
                            hour: 0,
                            min: 0
                        )
                    }
                return inBlocks
            }
        return blocks
    }
}



extension TimeBlockModel: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.groupKey == rhs.groupKey
    }
}
