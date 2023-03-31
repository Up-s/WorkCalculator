//
//  SettingView.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/07.
//

import UIKit

import RxSwift
import SnapKit
import Then
import UPsKit

final class SettingView: BaseView, NavigationProtocol {
  
  // MARK: - Property
  
  let navigationView: BaseNavigationView = BaseNavigationView(.pop).then { view in
    view.titleLabel.text = "설정"
  }
  
  private let contentsScrollView = UIScrollView()
  private let contentsStackView = UPsStackView(axis: .vertical, spacing: 40.0)
  let idView = SettingIDView()
  let daysView = SettingDaysView()
  let hourView = SettingHourSliderView()
  let weekPayView = SettingWeekPayView()
  let inputTypeView = SettingInputTypeView()
  let saveButton = UIButton().then { view in
    view.setTitle("저장", for: .normal)
    view.setTitleColor(.white, for: .normal)
    view.titleLabel?.font = .boldSystemFont(ofSize: 20.0)
    view.backgroundColor = .systemBlue
  }
  private let versionLabel = UILabel().then { view in
    view.font = .systemFont(ofSize: 12.0)
    let ver = "\((AppManager.CurrentVersion ?? "-"))(\((AppManager.CurrentBuild) ?? "-"))"
    let keyword: String
    #if Debug
    keyword = "debug_" + ver
    #else
    keyword = ver
    #endif
    let text = "앱버전   " + keyword
    let attri = NSMutableAttributedString.make(
      text: text,
      keyword: keyword,
      keywordFont: .systemFont(ofSize: 12.0),
      keywordColor: .gray700
    )
    view.attributedText = attri
  }
  
  
  
  // MARK: - Life Cycle
  
  override init() {
    super.init()
    
    self.setNavigation()
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
    
    [self.idView, self.daysView, self.hourView, self.weekPayView, self.inputTypeView, self.saveButton, self.versionLabel]
      .forEach(self.contentsStackView.addArrangedSubview(_:))
  }
  
  private func setConstraint() {
    let guide = self.safeAreaLayoutGuide
    
    self.contentsScrollView.snp.makeConstraints { make in
      make.top.equalTo(self.navigationView.snp.bottom)
      make.leading.trailing.bottom.equalTo(guide)
    }
    
    self.contentsStackView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.edges.equalToSuperview().inset(24.0)
    }
    
    self.saveButton.snp.makeConstraints { make in
      make.height.equalTo(48.0)
    }
  }
}
