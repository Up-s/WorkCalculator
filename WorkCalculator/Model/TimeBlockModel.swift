//
//  TimeBlockModel.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/05.
//

import Foundation

struct TimeBlockModel: Codable {
    
    let state: DateManager.State
    let weekday: DateManager.Day
    let year: Int
    let month: Int
    let day: Int
    var hour: Int
    var min: Int
    
    init(
        state: DateManager.State,
        weekday: DateManager.Day,
        year: Int,
        month: Int,
        day: Int,
        hour: Int,
        min: Int
    ) {
        self.state = state
        self.weekday = weekday
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.min = min
    }
}


extension TimeBlockModel {
    
    var interval: Int {
        (hour * 60) + min
    }
    
    var intervalString: String {
        String(format: "%02d:%02d", self.hour, self.min)
    }
    
    var info: String {
        self.weekday.ko + "요일 " + self.state.ko
    }
    
    var firebaseKey: String {
        "\(self.year)_\(self.month)_\(self.day)_\(self.state.en)"
    }
    
    var groupKey: String {
        "\(self.year)_\(self.month)_\(self.day)"
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
        let today = Date()
        let weekday = today.weekdayInt()
        let blocks = DateManager.Day.allCases
            .filter {
                AppManager.shared.settingData?.days.contains($0) ?? false
            }
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
