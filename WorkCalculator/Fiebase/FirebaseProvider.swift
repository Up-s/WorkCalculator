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
    
    
    
    class func shareID(_ shareID: String?) -> Observable<Void> {
        Observable<Void>.create { observer -> Disposable in
            
            guard let shareID = shareID else {
                observer.onError(FirebaseError.emptyData)
                return Disposables.create()
            }
            
            Firestore
                .firestore()
                .collection(FirebaseRoot.data)
                .document(shareID)
                .getDocument { snapshot, error in
                    if let error = error {
                        observer.onError(error)
                        
                    } else {
                        guard
                            let data = snapshot?.data(),
                            let settingData = try? FirebaseDecoder().decode(SettingModel.self, from: data)
                        else {
                            observer.onError(FirebaseError.emptyData)
                            return
                        }
                        
                        let currentID = UserDefaultsManager.firebaseID!
                        
                        Firestore
                            .firestore()
                            .collection(FirebaseRoot.data)
                            .document(currentID)
                            .delete()
                        
                        UserDefaultsManager.firebaseID = shareID
                        AppManager.shared.settingData = settingData
                        
                        observer.onNext(())
                        observer.onCompleted()
                    }
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
    
    
    
    class func setSettingData(_ data: SettingModel) -> Observable<Void> {
        Observable<Void>.create { observer -> Disposable in
            
            let documentID = UserDefaultsManager.firebaseID!
            
            if let encoderData = try? FirebaseEncoder().encode(data) as? [String: Any] {
                
                Firestore
                    .firestore()
                    .collection(FirebaseRoot.data)
                    .document(documentID)
                    .setData(encoderData) { error in
                        if let error = error {
                            observer.onError(error)
                            
                        } else {
                            AppManager.shared.settingData = data
                            
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
    
    
    class func setTimeBlock(_ block: TimeBlockModel) -> Observable<TimeBlockModel> {
        Observable<TimeBlockModel>.create { observer -> Disposable in
            
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
                        observer.onError(error)
                        
                    } else {
                        
                        let update = UpdateDateModel()
                        let updateData = try! FirebaseEncoder().encode(update) as! [String: Any]
                        
                        Firestore
                            .firestore()
                            .collection(FirebaseRoot.data)
                            .document(documentID)
                            .updateData(updateData)
                        
                        observer.onNext(block)
                        observer.onCompleted()
                    }
                }
            
            return Disposables.create()
        }
    }
}
