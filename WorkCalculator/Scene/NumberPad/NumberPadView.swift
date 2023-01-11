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
    
    private let contentsView = UIView()
    private let infoView = UIView().then { view in
        view.backgroundColor = .light
        view.layer.cornerRadius = 8.0
        view.layer.masksToBounds = true
    }
    let titleLabel = UILabel().then { view in
        view.textColor = .gray900
        view.textAlignment = .center
        view.font = .boldSystemFont(ofSize: 30.0)
    }
    let timerLabel = UILabel().then { view in
        view.textColor = .gray700
        view.textAlignment = .center
        view.font = .boldSystemFont(ofSize: 24.0)
    }
    let padCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .gray200
        collectionView.register(cellType: NumberPadCollectionViewCell.self)
        return collectionView
    }()
    let inputButtonView = InputButtonView()
    
    
    
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
        self.backgroundColor = .dark.withAlphaComponent(0.4)
        
        self.padCollectionView.delegate = self
        
        
        self.addSubview(self.contentsView)
        
        [self.infoView, self.inputButtonView]
            .forEach(self.contentsView.addSubview(_:))
        
        [self.titleLabel, self.timerLabel, self.padCollectionView]
            .forEach(self.infoView.addSubview(_:))
    }
    
    private func setConstraint() {
        let guide = self.safeAreaLayoutGuide
        
        self.contentsView.snp.makeConstraints { make in
            make.center.equalTo(guide)
            make.width.equalTo(280.0)
        }
        
        self.infoView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        self.inputButtonView.snp.makeConstraints { make in
            make.top.equalTo(self.infoView.snp.bottom).offset(16.0)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(64.0)
        }
        
        self.timerLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48.0)
        }
        
        self.padCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.timerLabel.snp.bottom).offset(24.0)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(240.0)
        }
    }
    
    private struct Metric {
        static let space: CGFloat = 2.0
    }
}



extension NumberPadView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(all: Metric.space)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Metric.space
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Metric.space
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = floor((collectionView.bounds.width - (Metric.space * 4)) / 3)
        let height: CGFloat = floor((collectionView.bounds.height - (Metric.space * 5)) / 4)
        return CGSize(width: width, height: height)
    }
}
