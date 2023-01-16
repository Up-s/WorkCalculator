//
//  UpdateView.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/11.
//

import UIKit

import SnapKit
import Then
import UPsKit

final class UpdateView: BaseView {
    
    // MARK: - Property
    
    var currentProgressView: ProgressView?
    
    
    
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
    
    func setProgress(_ progress: Int) {
        switch (progress % 100) == 0 {
        case true:
            let progressView = ProgressView()
            self.currentProgressView = progressView
            self.addSubview(progressView)
            progressView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.size.equalTo(240.0)
            }
            fallthrough
            
        case false:
            self.currentProgressView?.value = progress
        }
    }
    
    
    
    // MARK: - UI
    
    private func setAttribute() {
        self.backgroundColor = .light
    }
    
    private func setConstraint() {
        
    }
}
