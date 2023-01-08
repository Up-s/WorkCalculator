//
//  FirebaseProvider.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/06.
//

import CodableFirebase
import Firebase
import RxCocoa
import RxSwift

final class FirebaseProvider {
    
    
    
    class func create() -> Observable<Void> {
        Observable<Void>.create { observer -> Disposable in
            
            let setting = SettingModel()
            
            if let data = try? FirebaseEncoder().encode(setting) as? [String: Any] {
                
                let documentID = Firestore
                    .firestore()
                    .collection(FirebaseRoot.data)
                    .addDocument(data: data) { error in
                        if let error = error {
                            observer.onError(error)
                            
                        } else {
                            AppManager.shared.settingData = setting
                            
                            observer.onNext(())
                            observer.onCompleted()
                        }
                    }
                    .documentID
                
                UserDefaultsManager.firebaseID = documentID
                
            } else {
                observer.onError(FirebaseError.parsingError)
            }
            
            return Disposables.create()
        }
    }
    
    
    
    class func getSettingData() -> Observable<Void> {
        Observable<Void>.create { observer -> Disposable in
            
            let documentID = UserDefaultsManager.firebaseID!
            
            Firestore
                .firestore()
                .collection(FirebaseRoot.data)
                .document(documentID)
                .getDocument { snapshot, error in
                    if let error = error {
                        observer.onError(error)
                        
                    } else {
                        guard
                            let data = snapshot?.data(),
                            let settingData = try? FirebaseDecoder().decode(SettingModel.self, from: data)
                        else {
                            observer.onError(FirebaseError.parsingError)
                            return
                        }
                        
                        AppManager.shared.settingData = settingData
                        
                        observer.onNext(())
                        observer.onCompleted()
                    }
                }
            
            return Disposables.create()
        }
    }
    
    
    
    class func setSettingData() -> Observable<Void> {
        Observable<Void>.create { observer -> Disposable in
            
            let documentID = UserDefaultsManager.firebaseID!
            let settingData = AppManager.shared.settingData!
            
            if let data = try? FirebaseEncoder().encode(settingData) as? [String: Any] {
                
                Firestore
                    .firestore()
                    .collection(FirebaseRoot.data)
                    .document(documentID)
                    .setData(data) { error in
                        if let error = error {
                            observer.onError(error)
                            
                        } else {
                            observer.onNext(())
                            observer.onCompleted()
                        }
                    }
                
            } else {
                observer.onError(FirebaseError.parsingError)
            }
            
            return Disposables.create()
        }
    }
}
