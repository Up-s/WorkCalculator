//
//  MainViewProtocol.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/02/20.
//

import UIKit

import RxCocoa
import RxSwift
import UPsKit

protocol MainViewProtocol: UIView, NavigationProtocol {
  
  var clockViewButton: UIButton { get }
  var changeViewButton: UIButton { get }
  var refreshButton: UIButton { get }
  var histortButton: UIButton { get }
  var settingButton: UIButton { get }
  var weekPayTouchDown: Observable<Void>? { get }
  var weekPayTouchOut: Observable<Void>? { get }
  
  var blockViewModels: Binder<[MainBlockViewModel]> { get }
  var runTime: Binder<Int> { get }
  var notionData: Binder<NotionModel?> { get }
  var weekPay: Binder<String> { get }
}


extension MainViewProtocol {
  
  func setNavigationButton() {
    [self.clockViewButton, self.changeViewButton, self.refreshButton, self.histortButton, self.settingButton]
      .forEach(self.navigationView.addRightStackView(_:))
  }
}
