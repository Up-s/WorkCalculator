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
  
  private let notionOb = PublishRelay<Void>()
  private let firebaseOb = PublishRelay<Void>()
  private let emptyOb = PublishRelay<Void>()
  
  
  
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
        
        if currentArray[0] > minimumArray[0] {
          return true
          
        } else if currentArray[0] < minimumArray[0] {
          return false
          
        } else if currentArray[1] > minimumArray[1] {
          return true
          
        } else if currentArray[1] < minimumArray[1] {
          return false
          
        } else if currentArray[2] > minimumArray[2] {
          return true
          
        } else if currentArray[2] < minimumArray[2] {
          return false
          
        } else {
          return true
        }
      }
      .bind { [weak self] status in
        switch status {
        case true:
          self?.notionOb.accept(())

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
    
    
    self.notionOb
      .flatMap { NotionProvider.getMessage() }
      .`catch` { [weak self] error in
        guard let firebaseError = error as? NetworkError else { return Observable.empty() }

        let errorMessage: String
        switch firebaseError {
        case .emptyData:
          errorMessage = "데이터가 없습니다"
          
        case .parsingError:
          errorMessage = "잠시 후 다시 시도해 주세요.\nParsing Error"
          
        case .urlError:
          errorMessage = "URL Error"
          
        case .firebaseError(let error):
          errorMessage = "잠시 후 다시 시도해 주세요.\nService Error \(error.localizedDescription)"
        }

        self?.coordinator.toast(errorMessage)

        return Observable.empty()
      }
      .bind(to: self.firebaseOb)
      .disposed(by: self.disposeBag)

    self.firebaseOb
      .flatMap {
        UserDefaultsManager.firebaseID == nil ?
        FirebaseProvider.create() :
        FirebaseProvider.getSettingData()
      }
      .`catch` { [weak self] error in
        guard let firebaseError = error as? NetworkError else { return Observable.empty() }

        let errorMessage: String
        switch firebaseError {
        case .emptyData:
          errorMessage = "데이터가 없습니다"
          self?.emptyOb.accept(())
          
        case .parsingError:
          errorMessage = "잠시 후 다시 시도해 주세요.\nParsing Error"
          
        case .urlError:
          errorMessage = "URL Error"
          
        case .firebaseError(let error):
          errorMessage = "잠시 후 다시 시도해 주세요.\nService Error \(error.localizedDescription)"
        }

        self?.coordinator.toast(errorMessage)

        return Observable.empty()
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

        let viewModel = MainViewModel()
        let scene = Scene.main(viewModel)
        self?.coordinator.transition(scene: scene, style: .root)
      }
      .disposed(by: self.disposeBag)

    self.emptyOb
      .bind { [weak self] in
        let actions: [UPsAlertActionProtocol] = [
          UPsAlertAction(
            title: "재발급",
            handler: { _ in
              UserDefaultsManager.firebaseID = nil

              let scene = Scene.splash
              self?.coordinator.transition(scene: scene, style: .root)
            }
          ),
          UPsAlertCancelAction()
        ]

        self?.coordinator.alert(
          title: "데이터가 없습니다",
          actions: actions
        )
      }
      .disposed(by: self.disposeBag)
  }
}
