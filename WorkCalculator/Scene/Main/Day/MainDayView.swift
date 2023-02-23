//
//  MainDayView.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/02/21.
//

import UIKit

import RxSwift
import SnapKit
import Then
import UPsKit

final class MainDayView: BaseView, MainViewProtocol {
  
  // MARK: - Property
  
  let navigationView: BaseNavigationView = BaseNavigationView(.none(0.0)).then { view in
    view.titleLabel.text = "칼퇴 계산기"
  }
  let changeViewButton = UIButton().then { view in
    let image = UIImage.sfConfiguration(name: "rectangle.portrait.on.rectangle.portrait", color: .systemBlue)
    view.setImage(image, for: .normal)
  }
  let refreshButton = UIButton().then { view in
    let image = UIImage.sfConfiguration(name: "icloud.and.arrow.down", color: .systemBlue)
    view.setImage(image, for: .normal)
  }
  let histortButton = UIButton().then { view in
    let image = UIImage.sfConfiguration(name: "rectangle.stack", color: .systemBlue)
    view.setImage(image, for: .normal)
  }
  let settingButton = UIButton().then { view in
    let image = UIImage.sfConfiguration(name: "gearshape", color: .systemBlue)
    view.setImage(image, for: .normal)
  }
  
  private let contentsScrollView = UIScrollView().then { view in
    view.showsVerticalScrollIndicator = false
  }
  private let contentsStackView = UPsStackView(axis: .vertical)
  private let infoView = MainDayInfoView()
  private let messageView = MainDayMessageView()
  private let blockView = MainDayBlockView()
  
  private let disposeBag = DisposeBag()
  
  
  // MARK: - Life Cycle
  
  override init() {
    super.init()
    
    self.setNavigation()
    self.setNavigationButton()
    self.setAttribute()
    self.setConstraint()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  // MARK: - Interface
  
  var blockViewModels: Binder<[MainBlockViewModel]> {
    return Binder(self) { view, models in
      Observable.just(models)
        .bind(
          to: view.blockView.blockCollectionView.rx.items(
            cellIdentifier: MainDayBlockCollectionViewCell.identifier,
            cellType: MainDayBlockCollectionViewCell.self
          )
        ) { row, element, cell in
          cell.setData(element)
        }
        .disposed(by: view.disposeBag)
    }
  }
  
  var runTime: Binder<Int> {
    return Binder(self) { view, runTime in
      self.infoView.setData(runTime)
    }
  }
  
  var message: Binder<String?> {
    return Binder(self) { view, message in
      view.messageView.setMessage(message)
    }
  }
  
  
  
  
  // MARK: - UI
  
  private func setAttribute() {
    self.addSubview(self.contentsScrollView)
    
    self.contentsScrollView.addSubview(self.contentsStackView)
    
    [self.infoView, self.messageView, self.blockView]
      .forEach(self.contentsStackView.addArrangedSubview(_:))
  }
  
  private func setConstraint() {
    let guide = self.safeAreaLayoutGuide
    
    self.contentsScrollView.snp.makeConstraints { make in
      make.top.equalTo(self.navigationView.snp.bottom)
      make.leading.trailing.bottom.equalTo(guide)
    }
    
    self.contentsStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.width.equalToSuperview()
    }
  }
}
