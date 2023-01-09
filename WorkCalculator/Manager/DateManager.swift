//
//  DateManager.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/05.
//

import Foundation

class DateManager {
    
    enum Day: Codable, CaseIterable {
        case sun
        case mon
        case tue
        case wed
        case thu
        case fri
        case sat
        
        init(_ int: Int) {
            switch int {
            case 1: self = .sun
            case 2: self = .mon
            case 3: self = .tue
            case 4: self = .wed
            case 5: self = .thu
            case 6: self = .fri
            case 7: self = .sat
            default: fatalError()
            }
        }
        
        var ko: String {
            switch self {
            case .sun: return "일"
            case .mon: return "월"
            case .tue: return "화"
            case .wed: return "수"
            case .thu: return "목"
            case .fri: return "금"
            case .sat: return "토"
            }
        }
        
        var weekdayInt: Int {
            switch self {
            case .sun: return 1
            case .mon: return 2
            case .tue: return 3
            case .wed: return 4
            case .thu: return 5
            case .fri: return 6
            case .sat: return 7
            }
        }
        
        var startKey: UserDefaultsManager.Key {
            switch self {
            case .sun: return .sunStartTimeBlock
            case .mon: return .monStartTimeBlock
            case .tue: return .tueStartTimeBlock
            case .wed: return .wedStartTimeBlock
            case .thu: return .thuStartTimeBlock
            case .fri: return .friStartTimeBlock
            case .sat: return .satStartTimeBlock
            }
        }
        
        var endKey: UserDefaultsManager.Key {
            switch self {
            case .sun: return .sunEndTimeBlock
            case .mon: return .monEndTimeBlock
            case .tue: return .tueEndTimeBlock
            case .wed: return .wedEndTimeBlock
            case .thu: return .thuEndTimeBlock
            case .fri: return .friEndTimeBlock
            case .sat: return .satEndTimeBlock
            }
        }
        
        var restKey: UserDefaultsManager.Key {
            switch self {
            case .sun: return .sunRestTimeBlock
            case .mon: return .monRestTimeBlock
            case .tue: return .tueRestTimeBlock
            case .wed: return .wedRestTimeBlock
            case .thu: return .thuRestTimeBlock
            case .fri: return .friRestTimeBlock
            case .sat: return .satRestTimeBlock
            }
        }
    }
    
    enum State: Codable, CaseIterable {
        case start
        case end
        case rest
        
        var ko: String {
            switch self {
            case .start:  return "출근"
            case .end: return "퇴근"
            case .rest: return "휴식"
            }
        }
        
        var en: String {
            switch self {
            case .start:  return "start"
            case .end: return "end"
            case .rest: return "rest"
            }
        }
        
        var index: Int {
            switch self {
            case .start:  return 0
            case .end: return 1
            case .rest: return 2
            }
        }
    }
    
}
