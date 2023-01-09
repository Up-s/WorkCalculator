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
    
    var naviView: BaseNavigationView
    
    private let contentsScrollView = UIScrollView()
    private let contentsStackView = UPsStackView(axis: .vertical, spacing: 40.0)
    let idView = SettingIDView()
    let daysView = SettingDaysView()
    let hourView = SettingHourSliderView()
    let inputTypeView = SettingInputTypeView()
    let saveButton = UIButton().then { view in
        view.setTitle("저장", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = .boldSystemFont(ofSize: 20.0)
        view.backgroundColor = .systemBlue
    }
    
    
    
    // MARK: - Life Cycle
    
    override init() {
        self.naviView = BaseNavigationView(.dismiss)
        
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
        self.backgroundColor = .light
        
        self.naviView.navTitleLabel.text = "설정"
        
        
        self.addSubview(self.contentsScrollView)
        
        self.contentsScrollView.addSubview(self.contentsStackView)
        
        [self.idView, self.daysView, self.hourView, self.inputTypeView, saveButton]
            .forEach(self.contentsStackView.addArrangedSubview(_:))
    }
    
    private func setConstraint() {
        let guide = self.safeAreaLayoutGuide
        
        self.contentsScrollView.snp.makeConstraints { make in
            make.top.equalTo(self.naviView.snp.bottom)
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
