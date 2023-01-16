//
//  BlockModel.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/15.
//

import Foundation

struct BlockModel: Codable {
    
    let weekInfo: String
    let weekday: DateManager.Day
    let year: Int
    let month: Int
    let day: Int
    var startTime: Int
    var endTime: Int
    var restTime: Int
    
    init(
        weekInfo: String,
        weekday: DateManager.Day,
        year: Int,
        month: Int,
        day: Int,
        startTime: Int,
        endTime: Int,
        restTime: Int
    ) {
        self.weekInfo = weekInfo
        self.weekday = weekday
        self.year = year
        self.month = month
        self.day = day
        self.startTime = startTime
        self.endTime = endTime
        self.restTime = restTime
    }
    
    init(_ realm: RealmBlockModel) {
        self.weekInfo = realm.weekInfo
        self.weekday = realm.weekday
        self.year = realm.year
        self.month = realm.month
        self.day = realm.day
        self.startTime = realm.startTime
        self.endTime = realm.endTime
        self.restTime = realm.restTime
    }
}
    
    
extension BlockModel {
    
    var startHour: Int {
        self.startTime / 60
    }
    var startMin: Int {
        self.startTime % 60
    }
    var startIntervalString: String {
        String(format: "%02d:%02d", self.startHour, self.startMin)
    }
    
    
    
    var endHour: Int {
        self.endTime / 60
    }
    var endMin: Int {
        self.endTime % 60
    }
    var endIntervalString: String {
        String(format: "%02d:%02d", self.endHour, self.endMin)
    }
    
    
    
    var restHour: Int {
        self.restTime / 60
    }
    var restMin: Int {
        self.restTime % 60
    }
    var restIntervalString: String {
        String(format: "%02d:%02d", self.restHour, self.restMin)
    }
    
    
    
    var interval: Int {
        let startInterval = self.startTime
        let endInterval = self.endTime
        let restInterval = self.restTime
        return endInterval - startInterval - restInterval
    }
    
    var intervalString: String {
        let hour = self.interval / 60
        let min = self.interval % 60
        return String(format: "%d시간 %02d분", hour, min)
    }
    
    var date: Date {
        let dateComponents = DateComponents(year: self.year, month: self.month, day: self.day, hour: 0, minute: 0)
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        return calendar.date(from: dateComponents) ?? Date()
    }
    
    var info: String {
        "\(self.monthDay) (\(self.weekday.ko))       근무시간: \(self.intervalString)"
    }
    
    var monthDay: String {
        "\(self.month)월 \(self.day)일"
    }
    
    var key: String {
        "\(self.year)_\(self.month)_\(self.day)"
    }
}


extension BlockModel {
    
    func getInfo(_ state: DateManager.State) -> String {
        self.weekday.ko + "요일 " + state.ko
    }
    
    func getTime(_ state: DateManager.State) -> Int {
        switch state {
        case .start:
            return self.startTime
        case .end:
            return self.endTime
        case .rest:
            return self.restTime
        }
    }
    
    func getIntervalString(_ state: DateManager.State) -> String {
        switch state {
        case .start:
            return self.startIntervalString
        case .end:
            return self.endIntervalString
        case .rest:
            return self.restIntervalString
        }
    }
    
    mutating func updateTime(_ state: DateManager.State, time: Int) {
        switch state {
        case .start:
            self.startTime = time
        case .end:
            self.endTime = time
        case .rest:
            self.restTime = time
        }
    }
}



extension BlockModel {
    
    static var create: [BlockModel] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        
//        let testDateComp = DateComponents(year: 2023, month: 1, day: 5)
//        let testDate = calendar.date(from: testDateComp)!
        
//        let testDateComp = DateComponents(year: 2023, month: 1, day: 12)
//        let testDate = calendar.date(from: testDateComp)!
        
        let today = Date()
        let weekday = today.weekdayInt()
        
        let days = DateManager.Day.allCases
            .map { inDay -> Date in
                let tempWeekday = inDay.weekdayInt - weekday
                let tempTimeInterval = TimeInterval(tempWeekday * 24 * 60 * 60)
                return today + tempTimeInterval
            }
        
        let firstDay = days.first?.toString(.yyyyMMdd) ?? ""
        let lastDay = days.last?.toString(.yyyyMMdd) ?? ""
        let weekInfo = "\(firstDay)-\(lastDay)"
        
        return days
            .map { day -> BlockModel in
                BlockModel(
                    weekInfo: weekInfo,
                    weekday: DateManager.Day(day.weekdayInt()),
                    year: day.yearInt(),
                    month: day.monthInt(),
                    day: day.dayInt(),
                    startTime: 0,
                    endTime: 0,
                    restTime: 0
                )
            }
    }
}
