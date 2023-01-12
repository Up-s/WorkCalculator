//
//  SettingIDView.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/07.
//

import UIKit

import SnapKit
import Then
import UPsKit

final class SettingIDView: UIView {
    
    // MARK: - Property
    
    private let contentsStackView = UPsStackView(axis: .vertical, spacing: 8.0)
    private let titleLabel = SettingInfoLabel().then { view in
        view.text = "공유 아이디"
    }
    private let idStackView = UPsStackView(axis: .horizontal, spacing: 16.0, margin: UIEdgeInsets(all: 8.0)).then { view in
        view.backgroundColor = .gray200
    }
    private let idLabel = UILabel().then { view in
        view.text = UserDefaultsManager.firebaseID
        view.textColor = .gray900
        view.font = .boldSystemFont(ofSize: 20.0)
    }
    let copyButton = UIButton().then { view in
        view.setTitle("복사", for: .normal)
        view.setTitleColor(.light, for: .normal)
        view.titleLabel?.font = .boldSystemFont(ofSize: 18.0)
        view.backgroundColor = .gray600
    }
    let shareButton = UIButton().then { view in
        view.setTitle("등록", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = .boldSystemFont(ofSize: 18.0)
        view.backgroundColor = .systemTeal
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
        
        [self.titleLabel, self.idStackView, self.shareButton]
            .forEach(self.contentsStackView.addArrangedSubview(_:))
        
        [self.idLabel, self.copyButton]
            .forEach(self.idStackView.addArrangedSubview(_:))
    }
    
    private func setConstraint() {
        self.contentsStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.copyButton.snp.makeConstraints { make in
            make.width.equalTo(48.0)
        }
        
        self.shareButton.snp.makeConstraints { make in
            make.height.equalTo(40.0)
        }
    }
}
