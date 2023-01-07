//
//  SettingWeekView.swift
//  WorkCalculator
//
//  Created by UPs on 2023/01/07.
//

import UIKit

import SnapKit
import Then
import UPsKit

final class SettingWeekView: UIView {
    
    // MARK: - Property
    
    
    private let contentsStackView = UPsStackView(axis: .vertical, spacing: 8.0)
    private let titleLabel = SettingInfoLabel().then { view in
        view.text = "근무 요일"
    }
    let segmentedControl = UISegmentedControl(items: DateManager.Day.allCases.map { $0.ko }).then { view in
        view.isMultipleTouchEnabled = true
    }
    
    
    
    
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
        
    }
    
    private func setConstraint() {
        let guide = self.safeAreaLayoutGuide
        
    }
}
