//
//  SettingInputTypeView.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/07.
//

import UIKit

import SnapKit
import Then
import UPsKit

final class SettingInputTypeView: UIView {
    
    // MARK: - Property
    
    private let contentsStackView = UPsStackView(axis: .vertical, spacing: 8.0)
    private let titleLabel = SettingInfoLabel().then { view in
        view.text = "시간 입력 방법"
    }
    let segmentedControl = UISegmentedControl(items: InputType.allCases.map { $0.title }).then { view in
        let font = UIFont.boldSystemFont(ofSize: 16.0)
        view.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
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
        self.addSubview(self.contentsStackView)
        
        [self.titleLabel, self.segmentedControl]
            .forEach(self.contentsStackView.addArrangedSubview(_:))
    }
    
    private func setConstraint() {
        self.contentsStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16.0)
            make.leading.trailing.equalToSuperview().inset(24.0)
        }
        
        self.segmentedControl.snp.makeConstraints { make in
            make.height.equalTo(48.0)
        }
    }
}
