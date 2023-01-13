//
//  HistoryView.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/13.
//

import UIKit

import SnapKit
import Then
import UPsKit

final class HistoryView: BaseView, NavigationProtocol {
    
    // MARK: - Property
    
    var naviView: BaseNavigationView
    
    
    
    // MARK: - Life Cycle
    
    override init() {
        self.naviView = BaseNavigationView(.dismiss)
        
        super.init()
        
        self.setNavigation()
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
        
    }
}
