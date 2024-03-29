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
  
  class func minVersion() -> Observable<AppConfigureModel> {
    Observable<AppConfigureModel>.create { observer -> Disposable in
      
      Firestore
        .firestore()
        .collection(FirebaseRoot.app)
        .document(FirebaseRoot.configure)
        .getDocument { snapshot, error in
          if let error = error {
            observer.onError(NetworkError.firebaseError(error))
            
          } else {
            guard let data = snapshot?.data() else {
              observer.onError(NetworkError.emptyData)
              return
            }
            
            guard let appData = try? FirebaseDecoder().decode(AppConfigureModel.self, from: data) else {
              observer.onError(NetworkError.parsingError)
              return
            }
            
            observer.onNext(appData)
            observer.onCompleted()
          }
        }
      
      return Disposables.create()
    }
  }
  
  
  
  class func create() -> Observable<Void> {
    Observable<Void>.create { observer -> Disposable in
      
      let setting = SettingModel()
      let data = try! FirebaseEncoder().encode(setting) as! [String: Any]
      
      let documentID = Firestore
        .firestore()
        .collection(FirebaseRoot.data)
        .addDocument(data: data) { error in
          if let error = error {
            observer.onError(NetworkError.firebaseError(error))
            
          } else {
            AppManager.shared.settingData = setting
            RealmManager.deleteAll()
            
            observer.onNext(())
            observer.onCompleted()
          }
        }
        .documentID
      
      UserDefaultsManager.firebaseID = documentID
      
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
            observer.onError(NetworkError.firebaseError(error))
            
          } else {
            guard let data = snapshot?.data() else {
              observer.onError(NetworkError.emptyData)
              return
            }
            
            guard let settingData = try? FirebaseDecoder().decode(SettingModel.self, from: data) else {
              observer.onError(NetworkError.parsingError)
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
      let encoderData = try! FirebaseEncoder().encode(data) as! [String: Any]
      
      Firestore
        .firestore()
        .collection(FirebaseRoot.data)
        .document(documentID)
        .setData(encoderData) { error in
          if let error = error {
            observer.onError(NetworkError.firebaseError(error))
            
          } else {
            AppManager.shared.settingData = data
            
            observer.onNext(())
            observer.onCompleted()
          }
        }
      
      return Disposables.create()
    }
  }
  
  
  
  class func getBlock(_ block: BlockModel) -> Observable<BlockModel> {
    Observable<BlockModel>.create { observer -> Disposable in
      
      let documentID = UserDefaultsManager.firebaseID!
      
      Firestore
        .firestore()
        .collection(FirebaseRoot.data)
        .document(documentID)
        .collection(FirebaseRoot.block)
        .document(block.key)
        .getDocument { snapshot, error in
          if let error = error {
            observer.onError(NetworkError.firebaseError(error))
            
          } else {
            switch snapshot?.data() {
            case .none:
              self.createBlock(block) { result in
                switch result {
                case .failure(let error):
                  observer.onError(NetworkError.firebaseError(error))
                  
                case .success:
                  observer.onNext(block)
                  observer.onCompleted()
                }
              }
              
            case .some(let data):
              let temp = try! FirebaseDecoder().decode(BlockModel.self, from: data)
              
              observer.onNext(temp)
              observer.onCompleted()
            }
          }
        }
      
      return Disposables.create()
    }
  }
  
  
  
  class func createBlock(_ block: BlockModel, completion: @escaping (Result<Void, Error>) -> Void) {
    
    let documentID = UserDefaultsManager.firebaseID!
    
    var data = try! FirebaseEncoder().encode(block) as! [String: Any]
    let deviceList = AppManager.shared.settingData?.deviceList ?? []
    deviceList.forEach { deviceUUID in
      data[deviceUUID] = false
    }
    
    Firestore
      .firestore()
      .collection(FirebaseRoot.data)
      .document(documentID)
      .collection(FirebaseRoot.block)
      .document(block.key)
      .setData(data) { error in
        if let error = error {
          completion(.failure(error))
          
        } else {
          completion(.success(()))
        }
      }
  }
  
  
  
  class func setBlock(key: String, state: DateManager.State, runTime: Int) -> Observable<Int> {
    Observable<Int>.create { observer -> Disposable in
      
      let documentID = UserDefaultsManager.firebaseID!
      var data = [String: Any]()
      switch state {
      case .start:
        data[FirebaseFieldKey.startTime] = runTime
      case .end:
        data[FirebaseFieldKey.endTime] = runTime
      case .rest:
        data[FirebaseFieldKey.restTime] = runTime
      }
      
      Firestore
        .firestore()
        .collection(FirebaseRoot.data)
        .document(documentID)
        .collection(FirebaseRoot.block)
        .document(key)
        .updateData(data) { error in
          if let error = error {
            observer.onError(error)
            
          } else {
            let updateDate = UpdateDateModel()
            let updateDateData = try! FirebaseEncoder().encode(updateDate) as! [String: Any]
            
            Firestore
              .firestore()
              .collection(FirebaseRoot.data)
              .document(documentID)
              .updateData(updateDateData)
            
            observer.onNext(runTime)
            observer.onCompleted()
          }
        }
      
      return Disposables.create()
    }
  }
  
  
  // HistoryViewModel
  class func getHistoryBlock() -> Observable<[BlockModel]> {
    Observable<[BlockModel]>.create { observer -> Disposable in
      
      let documentID = UserDefaultsManager.firebaseID!
      let deviceUUID = UserDefaultsManager.deviceUUID!
      
      Firestore
        .firestore()
        .collection(FirebaseRoot.data)
        .document(documentID)
        .collection(FirebaseRoot.block)
        .whereField(deviceUUID, isEqualTo: false)
        .getDocuments { snapshot, error in
          if let error = error {
            observer.onError(NetworkError.firebaseError(error))
            
          } else {
            guard let documents = snapshot?.documents, documents.count > 0 else {
              observer.onError(NetworkError.emptyData)
              return
            }
            
            let blocks = documents.compactMap { document in
              try? FirebaseDecoder().decode(BlockModel.self, from: document.data())
            }
            
            var currentBlock = [BlockModel]()
            var oldBlock = [BlockModel]()
            
            blocks
              .forEach { block in
                let keys = AppManager.shared.blocks.compactMap { $0.key }
                switch keys.contains(block.key) {
                case true:
                  currentBlock.append(block)
                  
                case false:
                  oldBlock.append(block)
                }
              }
            
            oldBlock
              .forEach { block in
                self.updateDevice(block.key, state: true)
              }
            
            RealmManager.create(blocks: oldBlock)
            
            observer.onNext(currentBlock)
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
            observer.onError(NetworkError.firebaseError(error))
            
          } else {
            guard let data = snapshot?.data() else {
              observer.onError(NetworkError.emptyData)
              return
            }
            
            guard var settingData = try? FirebaseDecoder().decode(SettingModel.self, from: data) else {
              observer.onError(NetworkError.parsingError)
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
      .collection(FirebaseRoot.block)
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
      .collection(FirebaseRoot.block)
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
          
          RealmManager.deleteAll()
          
          Firestore
            .firestore()
            .collection(FirebaseRoot.data)
            .document(tempDocumentID)
            .collection(FirebaseRoot.block)
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
          
          Firestore
            .firestore()
            .collection(FirebaseRoot.data)
            .document(tempDocumentID)
            .updateData([FirebaseFieldKey.deviceList: deviceList])
        }
      )
        }
  
  
  
  class func deleteDevice(dataDocumentID: String, timeBlockDocumentID: String, deviceUUID: String) {
    Firestore
      .firestore()
      .collection(FirebaseRoot.data)
      .document(dataDocumentID)
      .collection(FirebaseRoot.block)
      .document(timeBlockDocumentID)
      .updateData([deviceUUID: FieldValue.delete()])
  }
  
  
  
  class func removeEmptyTime() {
    Firestore
      .firestore()
      .collection(FirebaseRoot.data)
      .getDocuments { dataSnapshot, dataError in
        if let error = dataError {
          print("\n---------- removeEmptyTime dataError ----------", error)
          
        } else {
          guard let dataDocuments = dataSnapshot?.documents.compactMap({ $0.documentID }) else { return }
          
          dataDocuments.forEach { dataID in
            Firestore
              .firestore()
              .collection(FirebaseRoot.data)
              .document(dataID)
              .collection(FirebaseRoot.block)
              .getDocuments { blockSnapshot, blockError in
                if let error = blockError {
                  print("\n---------- removeEmptyTime blockError ----------", error)
                  
                } else {
                  let fieldKey = "startTime"
                  
                  blockSnapshot?.documents
                    .compactMap { document -> String? in
                      let documentData = document.data()
                      guard let time = documentData[fieldKey] as? Int, time == 0 else { return nil }
                      return document.documentID
                    }
                    .forEach { blockID in
                      Firestore
                        .firestore()
                        .collection(FirebaseRoot.data)
                        .document(dataID)
                        .collection(FirebaseRoot.block)
                        .document(blockID)
                        .updateData([fieldKey: FieldValue.delete()])
                    }
                }
              }
          }
        }
      }
  }
}
