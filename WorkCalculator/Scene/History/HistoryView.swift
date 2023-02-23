//
//  HistoryView.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/13.
//

import UIKit

import SnapKit
import Then
import UPsKit

final class HistoryView: BaseView, NavigationProtocol {
  
  // MARK: - Property
  
  let navigationView: BaseNavigationView = BaseNavigationView(.pop).then { view in
    view.titleLabel.text = "이전 기록"
  }
  
  let tableView = UITableView().then { view in
    view.register(cellType: HistoryTableViewCell.self)
  }
  
  
  
  // MARK: - Life Cycle
  
  override init() {
    super.init()
    
    self.setNavigation()
    self.setAttribute()
    self.setConstraint()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  // MARK: - Interface
  
  
  
  // MARK: - UI
  
  private func setAttribute() {
    self.addSubview(self.tableView)
  }
  
  private func setConstraint() {
    let guide = self.safeAreaLayoutGuide
    
    self.tableView.snp.makeConstraints { make in
      make.top.equalTo(self.navigationView.snp.bottom)
      make.leading.trailing.bottom.equalTo(guide)
    }
  }
}
