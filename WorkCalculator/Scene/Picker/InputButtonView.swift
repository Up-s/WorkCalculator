//
//  InputButtonView.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/11.
//

import UIKit

import SnapKit
import Then
import UPsKit

final class InputButtonView: UIView {
    
    // MARK: - Property
    
    private let contentsStackView = UPsStackView(axis: .horizontal, distribution: .fillEqually, spacing: 2.0).then { view in
        view.backgroundColor = .gray200
        view.layer.cornerRadius = 8.0
        view.layer.masksToBounds = true
    }
    let cancelButton = UIButton().then { view in
        view.setTitle("취소", for: .normal)
        view.setTitleColor(.gray600, for: .normal)
        view.titleLabel?.font = .boldSystemFont(ofSize: 20.0)
    }
    let okButton = UIButton().then { view in
        view.setTitle("선택", for: .normal)
        view.setTitleColor(.gray900, for: .normal)
        view.titleLabel?.font = .boldSystemFont(ofSize: 20.0)
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
        
        [self.cancelButton, self.okButton]
            .forEach(self.contentsStackView.addArrangedSubview(_:))
    }
    
    private func setConstraint() {
        self.contentsStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(48.0)
        }
    }
}
