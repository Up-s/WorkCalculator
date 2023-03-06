//
//  MainDayInfoView.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/03/06.
//

import UIKit

import SnapKit
import Then
import UPsKit

final class MainDayInfoView: BaseView {
  
  // MARK: - Property
  
  private let contentsScrollView = UIScrollView().then { view in
    view.isPagingEnabled = true
    view.showsHorizontalScrollIndicator = false
  }
  private let contentsStackView = UPsStackView(axis: .horizontal)
  let progressView = MainDayProgressView()
  let weekPayView = MainDayWeekPayView()
  
  
  
  // MARK: - Life Cycle
  
  override init() {
    super.init()
    
    self.setAttribute()
    self.setConstraint()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  // MARK: - Interface
  
  
  
  // MARK: - UI
  
  private func setAttribute() {
    self.addSubview(self.contentsScrollView)
    
    self.contentsScrollView.addSubview(self.contentsStackView)
    
    [self.progressView, self.weekPayView]
      .forEach(self.contentsStackView.addArrangedSubview(_:))
  }
  
  private func setConstraint() {
    [self.contentsScrollView, self.contentsStackView].forEach { view in
      view.snp.makeConstraints { make in
        make.edges.equalToSuperview()
        make.height.equalTo(self.progressView)
      }
    }
    
    [self.progressView, self.weekPayView].forEach { view in
      view.snp.makeConstraints { make in
        make.width.equalTo(self.contentsScrollView)
      }
    }
  }
}
