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
    static let data = "data"
    static let timeBlock = "timeBlock"
}

struct FirebaseFieldKey {
    
    static let deviceList = "deviceList"
}

extension DocumentReference: DocumentReferenceType {}
extension GeoPoint: GeoPointType {}
extension FieldValue: FieldValueType {}
extension Timestamp: TimestampType {}
