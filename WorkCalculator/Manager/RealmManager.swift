//
//  RealmManager.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/13.
//

import Foundation

import RealmSwift
import RxCocoa
import RxSwift

final class RealmManager {
    
    class func create(blocks: [TimeBlockModel]) {
        do {
            let realm = try Realm()
            try realm.write {
                let data = blocks.map { block in
                    RealmTimeBlockModel(block)
                }
                realm.add(data)
            }
        } catch {
            print("\n😱😱😱😱😱😱", #fileID, #function, error)
        }
    }
    
    class func read() -> [TimeBlockModel]? {
        do {
            let realm = try Realm()
            let items = realm.objects(RealmTimeBlockModel.self)
            let realmArray = Array(items)
            let blocks = realmArray.map { item in
                TimeBlockModel(item)
            }
            return blocks
            
        } catch {
            print("\n😱😱😱😱😱😱", #fileID, #function, error)
            return nil
        }
    }
}
