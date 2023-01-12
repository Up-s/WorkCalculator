//
//  SplashView.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/05.
//

import UIKit

import SnapKit
import Then
import UPsKit

final class SplashView: BaseView {
    
    // MARK: - Property
    
    private let titleLabel = UILabel().then { view in
        view.textAlignment = .center
        view.text = "칼퇴 계산기"
        view.textColor = .gray900
        view.font = .boldSystemFont(ofSize: 40.0)
    }
    private let debugLabel = UILabel().then { view in
        view.text = "디버그"
        view.textColor = .red
        view.font = .boldSystemFont(ofSize: 20)
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
        self.backgroundColor = .gray100
        
        self.addSubview(self.titleLabel)
        
        #if DEBUG
        self.addSubview(self.debugLabel)
        #endif
    }
    
    private func setConstraint() {
        let guide = self.safeAreaLayoutGuide
        
        self.titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalTo(guide)
        }
        
        
        #if DEBUG
        self.debugLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp.bottom).offset(16.0)
        }
        #endif
    }
}
