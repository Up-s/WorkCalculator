//
//  DateManager.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/05.
//

import Foundation

class DateManager {
    
    enum Day: CaseIterable {
        case sun
        case mon
        case tue
        case wed
        case thu
        case fri
        case sat
        
        var title: String {
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
        
        var row: Int {
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
    }
    
    enum State: CaseIterable {
        case start
        case end
        case rest
        
        var title: String {
            switch self {
            case .start:  return "출근"
            case .end: return "퇴근"
            case .rest: return "휴식"
            }
        }
    }
    
}
