//
//  HistoryCollectionViewCell.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/16.
//

import UIKit

import SnapKit
import Then
import UPsKit

final class HistoryCollectionViewCell: UICollectionViewCell, CellIdentifiable {
    
    // MARK: - Property
    
    private let contentsStackView = UPsStackView(axis: .vertical).then { view in
        view.backgroundColor = .gray300
        view.layer.cornerRadius = 8.0
        view.layer.masksToBounds = true
    }
    private let dayLabel = UILabel().then { view in
        view.textAlignment = .center
        view.textColor = .gray900
        view.font = .boldSystemFont(ofSize: 40.0)
    }
    private let runTimeLabel = UILabel().then { view in
        view.textAlignment = .center
        view.textColor = .gray700
        view.font = .boldSystemFont(ofSize: 13.0)
    }
    
    
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setAttribute()
        self.setConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Interface
    
    func setData(_ data: BlockModel) {
        self.dayLabel.text = String(data.day)
        self.dayLabel.textColor = data.weekday.color
        
        self.runTimeLabel.text = data.intervalString
    }
    
    func setBorder(_ select: Bool) {
        self.contentsStackView.layer.borderColor = select ?
                                                    UIColor.systemBlue.cgColor :
                                                    UIColor.clear.cgColor
        self.contentsStackView.layer.borderWidth = 2.0
    }
    
    
    
    // MARK: - UI
    
    private func setAttribute() {
        self.contentView.addSubview(self.contentsStackView)
        
        [self.dayLabel, self.runTimeLabel]
            .forEach(self.contentsStackView.addArrangedSubview(_:))
    }
    
    private func setConstraint() {
        self.contentsStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.dayLabel.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.6)
        }
    }
}
