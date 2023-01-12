//
//  SettingHourSliderView.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/07.
//

import UIKit

import SnapKit
import Then
import UPsKit

final class SettingHourSliderView: UIView {
    
    // MARK: - Property
    
    private let contentsStackView = UPsStackView(axis: .vertical, spacing: 8.0)
    private let titleLabel = SettingInfoLabel().then { view in
        view.text = "총 근무시간"
    }
    private let hourStackView = UPsStackView(axis: .horizontal, spacing: 16.0, margin: UIEdgeInsets(all: 12.0)).then { view in
        view.backgroundColor = .gray200
    }
    let hourLabel = UILabel().then { view in
        view.textColor = .gray900
        view.font = .boldSystemFont(ofSize: 20.0)
    }
    let hourSlider = UISlider().then { view in
        view.minimumValue = 0
        view.maximumValue = 80
    }
    
    
    
    
    // MARK: - Life Cycle
    
    init() {
        super.init(frame: .zero)
        
        self.setAttribute()
        self.setConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Interface
    
    
    
    // MARK: - UI
    
    private func setAttribute() {
        let hour = AppManager.shared.settingData?.workBaseHour ?? 0
        self.hourLabel.text = String(hour) + "시간"
        self.hourSlider.value = Float(hour)
        
        
        
        self.addSubview(self.contentsStackView)
        
        [self.titleLabel, self.hourStackView]
            .forEach(self.contentsStackView.addArrangedSubview(_:))
        
        [self.hourLabel, self.hourSlider]
            .forEach(self.hourStackView.addArrangedSubview(_:))
    }
    
    private func setConstraint() {
        self.contentsStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.hourStackView.snp.makeConstraints { make in
            make.height.equalTo(56.0)
        }
        
        self.hourLabel.snp.makeConstraints { make in
            make.width.equalTo(64.0)
        }
    }
}
