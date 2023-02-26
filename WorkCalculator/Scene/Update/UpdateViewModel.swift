//
//  UpdateViewModel.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/11.
//

import Foundation

import RxCocoa
import RxSwift
import UPsKit

enum UpdateType {
  case refresh
  case share(String)
  case shareCancel
  case setting(SettingModel)
}

final class UpdateViewModel: BaseViewModel {
  
  struct Input {
    let viewDidAppear = PublishRelay<Void>()
  }
  
  struct Output {
    let progress = PublishRelay<Int>()
  }
  
  // MARK: - Property
  
  let input = Input()
  let output = Output()
  
  let inType: BehaviorRelay<UpdateType>
  private let timeObserver = Observable<Int>.interval(.milliseconds(5), scheduler: MainScheduler.instance)
  private let errorObserver = PublishRelay<Void>()
  
  
  
  // MARK: - Interface
  
  init(_ inType: UpdateType) {
    self.inType = BehaviorRelay<UpdateType>(value: inType)
    
    super.init()
    
    
    Observable
      .combineLatest(
        self.input.viewDidAppear.asObservable(),
        self.timeObserver.asObservable()
      ) { _, progress in
        return progress
      }
      .bind(to: self.output.progress)
      .disposed(by: self.disposeBag)
    
    self.input.viewDidAppear
      .flatMap {
        switch inType {
        case .refresh:
          return FirebaseProvider.getSettingData()
          
        case .share(let id):
          return FirebaseProvider.share(id)
          
        case .shareCancel:
          return FirebaseProvider.shareCancel()
          
        case .setting(let data):
          return FirebaseProvider.setSettingData(data)
        }
      }
      .`catch` { [weak self] error in
        guard let firebaseError = error as? NetworkError else { return Observable.empty() }

        let errorMessage: String
        switch firebaseError {
        case .emptyData:
          errorMessage = "데이터가 없습니다"
          
        case .parsingError:
          errorMessage = "잠시 후 다시 시도해 주세요.\nParsing Error"
          self?.errorObserver.accept(())
          
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
    
    self.errorObserver
      .delay(.seconds(4), scheduler: MainScheduler.instance)
      .bind { [weak self] in
        let scene = Scene.splash
        self?.coordinator.transition(scene: scene, style: .root)
      }
      .disposed(by: self.disposeBag)
  }
}
