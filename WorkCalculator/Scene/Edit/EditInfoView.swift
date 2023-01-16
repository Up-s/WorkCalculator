//
//  EditInfoView.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/13.
//

import UIKit

import SnapKit
import Then
import UPsKit

final class EditInfoView: UIView {
    
    // MARK: - Property
    
    private let emptyView = UIView()
    private let infoStackView = UPsStackView(axis: .horizontal, distribution: .fillEqually, spacing: 16.0)
    let startInfoLabel = UILabel().then { view in
        view.text = "출근"
    }
    let endInfoLabel = UILabel().then { view in
        view.text = "퇴근"
    }
    let restInfoLabel = UILabel().then { view in
        view.text = "휴식"
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
        [self.startInfoLabel, self.endInfoLabel, self.restInfoLabel].forEach { view in
            view.textAlignment = .center
            view.textColor = .gray900
            view.font = .boldSystemFont(ofSize: 16)
            view.backgroundColor = .gray200
        }
        
        
        
        [self.emptyView, self.infoStackView]
            .forEach(self.addSubview(_:))
        
        [self.startInfoLabel, self.endInfoLabel, self.restInfoLabel]
            .forEach(self.infoStackView.addArrangedSubview(_:))
    }
    
    private func setConstraint() {
        self.emptyView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.bottom.equalToSuperview()
            make.width.equalTo(48.0)
            make.height.equalTo(Metric.height)
        }
        
        self.infoStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(self.emptyView.snp.trailing).offset(16.0)
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(Metric.height)
        }
    }
    
    private struct Metric {
        static let height: CGFloat = 36.0
    }
}
