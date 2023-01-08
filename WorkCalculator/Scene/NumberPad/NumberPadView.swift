//
//  NumberPadView.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/08.
//

import UIKit

import SnapKit
import Then
import UPsKit

final class NumberPadView: BaseView {
    
    // MARK: - Property
    
    
    
    
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
