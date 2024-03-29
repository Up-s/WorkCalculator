//
//  MainDayMessageView.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/02/23.
//

import UIKit

import SnapKit
import Then
import UPsKit

final class MainDayMessageView: UIView {
  
  // MARK: - Property
  
  private let messageLabel = UPsPaddingLabel(x: 12.0, y: 8.0).then { view in
    view.adjustsFontSizeToFitWidth = true
    view.numberOfLines = 2
    view.backgroundColor = .gray200
    view.text = "QEDStudio"
    view.textAlignment = .center
    view.textColor = .gray900
    view.font = .boldSystemFont(ofSize: 18.0)
    view.layer.cornerRadius = 4.0
    view.layer.masksToBounds = true
  }
  
  private var previousMessage: String = ""
  
  
  
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
  
  func setMessage(_ data: NotionModel?) {
    var message = ""
    
    repeat {
      message = data?.messageList.randomElement() ?? ""
    } while self.previousMessage == message
    
    self.previousMessage = message
    
    let lastDay = AppManager.shared.settingData?.days.last?.ko ?? "-"
    let replaceMessage = message.replacingOccurrences(of: "[lastDay]", with: lastDay)
    
    UIView.transition(
      with: self.messageLabel,
      duration: 1.0,
      options: .transitionFlipFromBottom,
      animations: { [weak self] in
        self?.messageLabel.text = replaceMessage
        self?.messageLabel.textColor = data?.tag.textColor
        self?.messageLabel.backgroundColor = data?.tag.backgroundColor
        self?.layoutIfNeeded()
      }
    )
  }
  
  
  
  // MARK: - UI
  
  private func setAttribute() {
    self.addSubview(self.messageLabel)
  }
  
  private func setConstraint() {
    self.snp.makeConstraints { make in
      make.height.equalTo(88.0)
    }
    
    self.messageLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.width.equalToSuperview().inset(24.0)
      make.height.equalToSuperview().inset(8.0)
    }
  }
}
