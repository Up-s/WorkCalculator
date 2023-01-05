//
//  EidtUnitView.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/05.
//

import UIKit

import SnapKit
import Then
import UPsKit

final class EditUnitView: UIView {
    
    // MARK: - Property
    
    let dayLabel = UILabel().then { view in
        view.backgroundColor = .gray200
        view.textAlignment = .center
        view.textColor = .gray900
        view.font = .boldSystemFont(ofSize: 20.0)
    }
    private let dateStackView = UPsStackView(axis: .horizontal, distribution: .fillEqually, spacing: 16.0)
    let startTimeButton = UIButton()
    let endTimeButton = UIButton()
    let restTimeButton = UIButton()
    let runTimeInfoLabel = UILabel().then { view in
        view.text = "일일근무시간"
        view.textColor = .gray900
        view.font = .systemFont(ofSize: 16.0)
    }
    let runTimeLabel = UILabel().then { view in
        view.textColor = .gray900
        view.font = .boldSystemFont(ofSize: 16.0)
    }
    
    let day: DateManager.Day
    
    
    
    // MARK: - Life Cycle
    
    init(_ day: DateManager.Day) {
        self.day = day
        
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
        self.dayLabel.text = day.title
        
        [self.startTimeButton, self.endTimeButton, self.restTimeButton].forEach {
            $0.setTitle("00:00", for: .normal)
            $0.setTitleColor(.gray900, for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 20.0)
            $0.backgroundColor = .gray200
        }
        
        
        [self.dayLabel, self.dateStackView, self.runTimeInfoLabel, self.runTimeLabel]
            .forEach(self.addSubview(_:))
        
        [self.startTimeButton, self.endTimeButton, self.restTimeButton]
            .forEach(self.dateStackView.addArrangedSubview(_:))
    }
    
    private func setConstraint() {
        self.dayLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.size.equalTo(Metric.size)
        }
        
        self.dateStackView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.leading.equalTo(self.dayLabel.snp.trailing).offset(16.0)
            make.height.equalTo(Metric.size)
        }
        
        self.runTimeInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(self.dateStackView.snp.bottom).offset(8.0)
            make.leading.equalTo(self.dateStackView)
            make.bottom.equalToSuperview()
        }
        self.runTimeInfoLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        self.runTimeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.runTimeInfoLabel)
            make.leading.equalTo(self.runTimeInfoLabel.snp.trailing).offset(8.0)
            make.trailing.equalTo(self.dateStackView)
        }
    }
    
    private struct Metric {
        static let size: CGFloat = 48.0
    }
}
