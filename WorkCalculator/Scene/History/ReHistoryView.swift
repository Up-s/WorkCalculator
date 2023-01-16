//
//  ReHistoryView.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/16.
//

import UIKit

import SnapKit
import Then
import UPsKit

final class ReHistoryView: BaseView, NavigationProtocol {
    
    // MARK: - Property
    
    var navigationView: BaseNavigationView
    
    private let contentsStackView = UPsStackView(axis: .vertical)
    let titleLabel = UILabel().then { view in
        view.textAlignment = .center
        view.textColor = .gray800
        view.font = .boldSystemFont(ofSize: 25.0)
    }
    let dayCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(cellType: HistoryCollectionViewCell.self)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    private let emptyView = UIView()
    
    
    
    // MARK: - Life Cycle
    
    override init() {
        self.navigationView = BaseNavigationView(.pop)
        
        super.init()
        
        self.setNavigation()
        self.setAttribute()
        self.setConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Interface
    
    func setData(_ data: BlockModel) {
        
    }
    
    
    
    // MARK: - UI
    
    private func setAttribute() {
        self.backgroundColor = .light
        
        self.navigationView.titleLabel.text = "이전 기록"
        
        self.dayCollectionView.delegate = self
        
        
        
        self.addSubview(self.contentsStackView)
        
        [self.titleLabel, self.dayCollectionView, self.emptyView]
            .forEach(self.contentsStackView.addArrangedSubview(_:))
    }
    
    private func setConstraint() {
        let guide = self.safeAreaLayoutGuide
        
        self.contentsStackView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationView.snp.bottom)
            make.leading.trailing.bottom.equalTo(guide)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.height.equalTo(48.0)
        }
        
        self.dayCollectionView.snp.makeConstraints { make in
            make.height.equalTo(104.0)
        }
    }
    
    private struct Metric {
        static let xInset: CGFloat = 12.0
        static let yInset: CGFloat = 8.0
    }
}



extension ReHistoryView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(x: Metric.xInset, y: Metric.yInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Metric.xInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.bounds.height - (Metric.yInset * 2)
        return CGSize(width: size, height: size)
    }
}
