//
//  HistoryTableViewCell.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/14.
//

import UIKit

import SnapKit
import Then
import UPsKit

final class HistoryTableViewCell: UITableViewCell, CellIdentifiable {
  
  // MARK: - Property
  
  private let contentsStackView = UPsStackView(axis: .vertical, spacing: 8.0)
  private let titleLabel = UILabel().then { view in
    view.textColor = .gray700
    view.font = .boldSystemFont(ofSize: 15.0)
  }
  private let timeBlcokStackView = UPsStackView(axis: .horizontal, distribution: .fillEqually, spacing: 12.0)
  
  
  
  // MARK: - Life Cycle
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.setAttribute()
    self.setConstraint()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    self.timeBlcokStackView.subviews.forEach { view in
      view.removeFromSuperview()
    }
  }
  
  
  
  // MARK: - Interface
  
  func setData(_ data: BlockModel) {
    self.titleLabel.text = data.info
    
    let startView = HistoryTimeBlockView()
    startView.titleLabel.text = DateManager.State.start.ko
    startView.timeLabel.text = data.startIntervalString
    
    let endView = HistoryTimeBlockView()
    endView.titleLabel.text = DateManager.State.end.ko
    endView.timeLabel.text = data.endIntervalString
    
    let restView = HistoryTimeBlockView()
    restView.titleLabel.text = DateManager.State.rest.ko
    restView.timeLabel.text = data.restIntervalString
    
    [startView, endView, restView]
      .forEach(self.timeBlcokStackView.addArrangedSubview(_:))
  }
  
  
  
  // MARK: - UI
  
  private func setAttribute() {
    self.selectionStyle = .none
    self.backgroundColor = .clear
    
    
    
    self.contentView.addSubview(self.contentsStackView)
    
    [self.titleLabel, self.timeBlcokStackView]
      .forEach(self.contentsStackView.addArrangedSubview(_:))
  }
  
  private func setConstraint() {
    self.contentsStackView.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview().inset(16.0)
      make.leading.trailing.equalToSuperview().inset(24.0)
    }
  }
}
