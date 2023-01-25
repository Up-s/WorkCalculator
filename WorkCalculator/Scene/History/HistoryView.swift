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
  
  var navigationView: BaseNavigationView
  
  let tableView = UITableView().then { view in
    view.register(cellType: HistoryTableViewCell.self)
  }
  
  
  
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
  
  
  
  // MARK: - UI
  
  private func setAttribute() {
    self.backgroundColor = .light
    
    self.navigationView.titleLabel.text = "이전 기록"
    
    
    
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
