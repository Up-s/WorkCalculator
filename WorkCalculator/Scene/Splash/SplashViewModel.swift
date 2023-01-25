//
//  SplashViewModel.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/05.
//

import Foundation

import RxCocoa
import RxSwift
import UPsKit

final class SplashViewModel: BaseViewModel {
    
    struct Input {
        let viewDidAppear = PublishRelay<Void>()
    }
    
    struct Output {
    }
    
    // MARK: - Property
    
    let input = Input()
    let output = Output()
    
    private let firebaseOb = PublishRelay<Void>()
    
    
    
    // MARK: - Interface
    
    init() {
        super.init()
        
        self.input.viewDidAppear
            .flatMap {
                FirebaseProvider.minVersion()
            }
            .map { configure -> Bool in
                let currentVer = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
                let currentArray = currentVer.components(separatedBy: ".").compactMap { Int($0) }
                let minimumArray = configure.minVersion
                
                var status = false
                for i in 0..<3 {
                    let min = minimumArray[i]
                    let cur = currentArray[i]
                    status = min <= cur
                    guard status else { break }
                    continue
                }
                
                return status
            }
            .bind { [weak self] status in
                switch status {
                case true:
                    self?.firebaseOb.accept(())
                    
                case false:
                    let action = UPsAlertAction(
                        title: "확인",
                        style: .default,
                        handler: { _ in
                            guard let url = URL(string: AppManager.appstoreURL) else { return }
                            UIApplication.shared.open(url)
                        }
                    )
                    
                    self?.coordinator.alert(
                        title: "업데이트",
                        message: "새 버전이 업데이트 되었습니다.\n업데이트 후 사용하실 수 있습니다.\n확인을 누르시면 앱스토어로 이동합니다.",
                        actions: [action]
                    )
                }
            }
            .disposed(by: self.disposeBag)
        
        self.firebaseOb
            .flatMap {
                UserDefaultsManager.firebaseID == nil ?
                    FirebaseProvider.create() :
                    FirebaseProvider.getSettingData()
            }
            .catch { [weak self] error in
                self?.base.networkError.accept(error)
                return .empty()
            }
            .map { BlockModel.create }
            .flatMap { blocks in
                Observable.from(blocks)
                    .flatMap { block in
                        FirebaseProvider.getBlock(block)
                    }
                    .toArray()
                    .map { blocks in
                        blocks.sorted { $0.date < $1.date }
                    }
            }
            .bind { [weak self] blocks in
                AppManager.shared.blocks = blocks

                let scene = Scene.edit
                self?.coordinator.transition(scene: scene, style: .root)
            }
            .disposed(by: self.disposeBag)
    }
}
