//
//  FirebaseRoot.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/06.
//

import Foundation

import CodableFirebase
import Firebase

struct FirebaseRoot {
    
    static let app = "app"
    static let configure = "configure"
    
    static let data = "data"
    static let block = "block"
}

struct FirebaseFieldKey {
    
    static let deviceList = "deviceList"
    static let startTime = "startTime"
    static let endTime = "endTime"
    static let restTime = "restTime"
}

extension DocumentReference: DocumentReferenceType {}
extension GeoPoint: GeoPointType {}
extension FieldValue: FieldValueType {}
extension Timestamp: TimestampType {}
