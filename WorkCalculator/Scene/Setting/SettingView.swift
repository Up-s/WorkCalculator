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
    private let contentsStackView = UPsStackView(axis: .vertical, spacing: 16.0)
    let idView = SettingIDView()
    let hourView = SettingHourSliderView()
    let inputTypeView = SettingInputTypeView()
    
    
    
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
    
    var setSettingData: Binder<SettingModel> {
        Binder(self) { view, data in
            view.hourView.hourSlider.value = Float(data.workBaseHour)
            view.hourView.hourLabel.text = String(data.workBaseHour) + "시간"
        }
    }
    
    
    
    // MARK: - UI
    
    private func setAttribute() {
        self.backgroundColor = .light
        
        self.naviView.navTitleLabel.text = "설정"
        
        
        self.addSubview(self.contentsScrollView)
        
        self.contentsScrollView.addSubview(self.contentsStackView)
        
        [self.idView, self.inputTypeView, self.hourView]
            .forEach(self.contentsStackView.addArrangedSubview(_:))
    }
    
    private func setConstraint() {
        let guide = self.safeAreaLayoutGuide
        
        self.contentsScrollView.snp.makeConstraints { make in
            make.top.equalTo(self.naviView.snp.bottom)
            make.leading.trailing.bottom.equalTo(guide)
        }
        
        self.contentsStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
}
