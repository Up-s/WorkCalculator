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
    
    
    // SplashViewModel
    class func create() -> Observable<Void> {
        Observable<Void>.create { observer -> Disposable in
            
            let setting = SettingModel()
            let data = try! FirebaseEncoder().encode(setting) as! [String: Any]
            
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
            
            return Disposables.create()
        }
    }
    
    
    // SplashViewModel
    // UpdateViewModel
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
    
    
    // UpdateViewModel
    class func setSettingData(_ data: SettingModel) -> Observable<Void> {
        Observable<Void>.create { observer -> Disposable in
            
            let documentID = UserDefaultsManager.firebaseID!
            let encoderData = try! FirebaseEncoder().encode(data) as! [String: Any]
            
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
            
            return Disposables.create()
        }
    }
    
    
    // SplashViewMdoel
    // UpdateViewModel
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
                            let temp = try! FirebaseDecoder().decode(TimeBlockModel.self, from: data)
                            
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
        let deviceUUID = UserDefaultsManager.deviceUUID!
        
        var data = try! FirebaseEncoder().encode(block) as! [String: Any]
        data[deviceUUID] = false
        
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
    
    // PickerViewModel
    // NumberPadViewModel
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
    
    
    // HistoryViewModel
    class func getAllTimeBlock() -> Observable<[TimeBlockModel]> {
        Observable<[TimeBlockModel]>.create { observer -> Disposable in
            
            let documentID = UserDefaultsManager.firebaseID!
            let deviceUUID = UserDefaultsManager.deviceUUID!
            
            Firestore
                .firestore()
                .collection(FirebaseRoot.data)
                .document(documentID)
                .collection(FirebaseRoot.timeBlock)
                .whereField(deviceUUID, isEqualTo: false)
                .getDocuments { snapshot, error in
                    if let error = error {
                        observer.onError(error)
                        
                    } else {
                        guard let documents = snapshot?.documents else {
                            observer.onError(FirebaseError.parsingError)
                            return
                        }
                        
                        let blocks = documents.compactMap { document in
                            try? FirebaseDecoder().decode(TimeBlockModel.self, from: document.data())
                        }
                        
                        let filterBlocks = blocks
                            .filter { block in
                                let keys = AppManager.shared.timeBlocks.compactMap { $0.first?.groupKey }
                                return !keys.contains(block.groupKey)
                            }
                        
                        filterBlocks
                            .forEach { block in
                                self.updateDevice(block.firebaseKey, state: true)
                            }
                        
                        RealmManager.create(blocks: filterBlocks)
                        
                        observer.onNext(blocks)
                        observer.onCompleted()
                    }
                }
            
            return Disposables.create()
        }
    }
    
    
    // UpdateViewModel
    class func share(_ shareID: String) -> Observable<Void> {
        Observable<Void>.create { observer -> Disposable in
            
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
                            var settingData = try? FirebaseDecoder().decode(SettingModel.self, from: data)
                        else {
                            observer.onError(FirebaseError.emptyData)
                            return
                        }
                        
                        // 기존 데이터 삭제
                        let deleteDocumentID = UserDefaultsManager.firebaseID!
                        Firestore
                            .firestore()
                            .collection(FirebaseRoot.data)
                            .document(deleteDocumentID)
                            .delete()
                        
                        
                        // 데이터 추가
                        settingData.deviceList.append(UserDefaultsManager.deviceUUID!)
                        
                        AppManager.shared.settingData = settingData
                        UserDefaultsManager.firebaseID = shareID
                        RealmManager.deleteAll()
                        
                        self.addDevice()
                        
                        observer.onNext(())
                        observer.onCompleted()
                    }
                }
            
            return Disposables.create()
        }
    }
    
    
    
    class func addDevice() {
        let documentID = UserDefaultsManager.firebaseID!
        let deviceList = AppManager.shared.settingData?.deviceList ?? []
        
        guard !deviceList.isEmpty else { return }
        
        Firestore
            .firestore()
            .collection(FirebaseRoot.data)
            .document(documentID)
            .updateData([FirebaseFieldKey.deviceList: deviceList])
        
        Firestore
            .firestore()
            .collection(FirebaseRoot.data)
            .document(documentID)
            .collection(FirebaseRoot.timeBlock)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("\n😱😱😱😱😱😱", #fileID, #function, error)
                    
                } else {
                    guard let documents = snapshot?.documents else {
                        return
                    }
                    
                    documents
                        .map { $0.documentID }
                        .forEach {
                            self.updateDevice($0, state: false)
                        }
                }
            }
    }
    
    
    
    class func updateDevice(_ document: String, state: Bool) {
        let documentID = UserDefaultsManager.firebaseID!
        let deviceUUID = UserDefaultsManager.deviceUUID!
        
        Firestore
            .firestore()
            .collection(FirebaseRoot.data)
            .document(documentID)
            .collection(FirebaseRoot.timeBlock)
            .document(document)
            .updateData([deviceUUID: state])
    }
    
    
    // UpdateViewModel
    class func shareCancel() -> Observable<Void>  {
        let tempDocumentID = UserDefaultsManager.firebaseID!
        let tempDeviceUUID = UserDefaultsManager.deviceUUID!
        let tempDeviceList = AppManager.shared.settingData?.deviceList
        
        return self.create()
            .do(
                onNext: {
                    var deviceList = [String]()
                    
                    if var list = tempDeviceList, let firstIndex = list.firstIndex(of: tempDeviceUUID) {
                        list.remove(at: firstIndex)
                        deviceList = list
                    }
                    
                    guard !deviceList.isEmpty else { return }
                    
                    Firestore
                        .firestore()
                        .collection(FirebaseRoot.data)
                        .document(tempDocumentID)
                        .updateData([FirebaseFieldKey.deviceList: deviceList])
                    
                    Firestore
                        .firestore()
                        .collection(FirebaseRoot.data)
                        .document(tempDocumentID)
                        .collection(FirebaseRoot.timeBlock)
                        .getDocuments { snapshot, error in
                            if let error = error {
                                print("\n😱😱😱😱😱😱", #fileID, #function, error)
                                
                            } else {
                                guard let documents = snapshot?.documents else {
                                    return
                                }
                                
                                documents
                                    .map { $0.documentID }
                                    .forEach {
                                        self.deleteDevice(
                                            dataDocumentID: tempDocumentID,
                                            timeBlockDocumentID: $0,
                                            deviceUUID: tempDeviceUUID
                                        )
                                    }
                            }
                        }
                }
            )
    }
    
    
    
    class func deleteDevice(dataDocumentID: String, timeBlockDocumentID: String, deviceUUID: String) {
        Firestore
            .firestore()
            .collection(FirebaseRoot.data)
            .document(dataDocumentID)
            .collection(FirebaseRoot.timeBlock)
            .document(timeBlockDocumentID)
            .updateData([deviceUUID: FieldValue.delete()])
    }
}
