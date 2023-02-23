//
//  MainViewProtocol.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/02/20.
//

import UIKit

import RxSwift
import UPsKit

protocol MainViewProtocol: UIView, NavigationProtocol {
  
  var changeViewButton: UIButton { get }
  var refreshButton: UIButton { get }
  var histortButton: UIButton { get }
  var settingButton: UIButton { get }
  
  var blockViewModels: Binder<[MainBlockViewModel]> { get }
  var runTime: Binder<Int> { get }
  var message: Binder<String?> { get }
}


extension MainViewProtocol {
  
  func setNavigationButton() {
    [self.changeViewButton, self.refreshButton, self.histortButton, self.settingButton]
      .forEach(self.navigationView.addNavigationRightStackView(_:))
  }
}
