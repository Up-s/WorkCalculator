//
//  MainDayBlockView.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/02/23.
//

import UIKit

import SnapKit
import Then
import UPsKit

final class MainDayBlockView: UIView {
  
  // MARK: - Property
  
  let blockCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(cellType: MainDayBlockCollectionViewCell.self)
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.backgroundColor = .clear
    collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
    return collectionView
  }()
  
  
  
  // MARK: - Life Cycle
  
  init() {
    super.init(frame: .zero)
    
    self.setAttribute()
    self.setConstraint()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private var isLayoutSubviews = false
  override func layoutSubviews() {
    super.layoutSubviews()
    
    if self.isLayoutSubviews == false {
      self.isLayoutSubviews = true
      
      let days = AppManager.shared.settingData?.days
        .map { $0.weekdayInt }
        .reversed() ?? []
      let todayWeekdayInt = Date().weekdayInt()
      var weekdayInt = 0
      for day in days {
        guard day <= todayWeekdayInt else { continue }
        weekdayInt = day
        break
      }
      let dayIndex: Int = days.reversed().firstIndex(of: weekdayInt) ?? 0
      let x = ((self.blockCollectionView.bounds.width - Metric.xInset - Metric.padding) * CGFloat(dayIndex))
      let point = CGPoint(x: x, y: .zero)
      self.blockCollectionView.setContentOffset(point, animated: false)
    }
  }
  
  
  
  // MARK: - Interface
  
  
  
  // MARK: - UI
  
  private func setAttribute() {
    self.blockCollectionView.delegate = self
    
    
    
    self.addSubview(self.blockCollectionView)
  }
  
  private func setConstraint() {
    self.snp.makeConstraints { make in
      make.height.equalTo(420.0)
    }
    
    self.blockCollectionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private struct Metric {
    static let xInset: CGFloat = 24.0
    static let yInset: CGFloat = 24.0
    static let spacing: CGFloat = 12.0
    static let padding: CGFloat = 12.0
  }
}



// MARK: - UICollectionViewDelegate

extension MainDayBlockView: UICollectionViewDelegate {
  
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    let width = scrollView.bounds.size.width - Metric.xInset - Metric.spacing - Metric.padding
    let cellWidthIncludingSpacing = width + Metric.spacing
    var offset = targetContentOffset.pointee
    let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
    var roundedIndex = round(index)
    
    if scrollView.contentOffset.x > targetContentOffset.pointee.x {
      roundedIndex = floor(index)
    } else {
      roundedIndex = ceil(index)
    }
    
    offset = CGPoint(
      x: (roundedIndex * cellWidthIncludingSpacing) - scrollView.contentInset.left,
      y: -scrollView.contentInset.top
    )
    targetContentOffset.pointee = offset
  }
}



// MARK: - UICollectionViewDelegateFlowLayout

extension MainDayBlockView: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    UIEdgeInsets(x: Metric.xInset, y: Metric.yInset)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    Metric.spacing
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    .zero
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.bounds.width - Metric.xInset - Metric.spacing - Metric.padding
    let height = collectionView.bounds.height - (Metric.yInset * 2)
    return CGSize(width: width, height: height)
  }
}
