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
        String(format: "%d:%02d", self.hour, self.min)
    }
    
    var info: String {
        self.weekday.ko + "요일 " + self.state.ko
    }
    
    var firebaseKey: String {
        "\(self.year)_\(self.month)_\(self.day)_\(self.state.rawValue)"
    }
    
    var groupKey: String {
        "\(self.year)_\(self.month)_\(self.day)"
    }
    
    var date: Date {
        let tempDay = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        let dateComponents = DateComponents(year: tempDay.year, month: tempDay.month, day: tempDay.day, hour: 0, minute: 0)
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        return calendar.date(from: dateComponents) ?? Date()
    }
}



extension TimeBlockModel: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.groupKey == rhs.groupKey
    }
}
