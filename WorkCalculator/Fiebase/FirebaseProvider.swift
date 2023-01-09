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
    
    
    class func getTimeBlock(_ block: TimeBlockModel) -> Observable<TimeBlockModel> {
        Observable<TimeBlockModel>.create { observer -> Disposable in
            
            let documentID = UserDefaultsManager.firebaseID!
            
            Firestore
                .firestore()
                .collection(FirebaseRoot.data)
                .document(documentID)
                .collection(FirebaseRoot.timeBlock)
                .document(block.firebaseKey)
                .getDocument { snapshot, error in
                    
                    if let error = error {
                        observer.onError(error)
                        
                    } else {
                        switch snapshot?.data() {
                        case .none:
                            self.createTimeBlock(block) { result in
                                switch result {
                                case .failure(let error):
                                    observer.onError(error)
                                    
                                case .success:
                                    observer.onNext(block)
                                    observer.onCompleted()
                                }
                            }
                            
                        case .some(let data):
                            guard let temp = try? FirebaseDecoder().decode(TimeBlockModel.self, from: data) else {
                                observer.onError(FirebaseError.parsingError)
                                return
                            }
                            observer.onNext(temp)
                            observer.onCompleted()
                        }
                    }
                }
            
            return Disposables.create()
        }
    }
    
    class func createTimeBlock(_ block: TimeBlockModel, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let documentID = UserDefaultsManager.firebaseID!
        let data = try! FirebaseEncoder().encode(block) as! [String: Any]
        
        Firestore
            .firestore()
            .collection(FirebaseRoot.data)
            .document(documentID)
            .collection(FirebaseRoot.timeBlock)
            .document(block.firebaseKey)
            .setData(data) { error in
                if let error = error {
                    completion(.failure(error))
                    
                } else {
                    completion(.success(()))
                }
            }
    }
}
