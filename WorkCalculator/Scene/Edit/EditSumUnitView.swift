//
//  EditSumUnitView.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/06.
//

import UIKit

import SnapKit
import Then
import UPsKit

final class EditSumUnitView: UIView {
    
    // MARK: - Property
    
    private let contentsStackView = UPsStackView(axis: .vertical, spacing: 8.0)
    let titleLabel = UILabel().then { view in
        view.font = .boldSystemFont(ofSize: 20.0)
    }
    let subLabel = UILabel().then { view in
        view.font = .boldSystemFont(ofSize: 22.0)
        view.numberOfLines = 2
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
        [self.titleLabel, self.subLabel].forEach { view in
            view.backgroundColor = .gray300
            view.textAlignment = .center
            view.textColor = .gray900
        }
        
        
        
        self.addSubview(self.contentsStackView)
        
        [self.titleLabel, self.subLabel]
            .forEach(self.contentsStackView.addArrangedSubview(_:))
    }
    
    private func setConstraint() {
        self.contentsStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.height.equalTo(40.0)
        }
        
        self.subLabel.snp.makeConstraints { make in
            make.height.equalTo(88.0)
        }
    }
}
