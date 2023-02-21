//
//  MainDayInfoView.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/02/21.
//

import UIKit

import SnapKit
import Then
import UPsKit

final class MainDayInfoView: UIView {
  
  // MARK: - Property
  
  private let runTimeLabel = UPsPaddingLabel(x: 4.0, y: 2.0).then { view in
    view.backgroundColor = .gray200
    view.text = "0시간 00분"
    view.textAlignment = .center
    view.textColor = .gray900
    view.font = .boldSystemFont(ofSize: 16.0)
    view.layer.cornerRadius = 4.0
    view.layer.masksToBounds = true
  }
  private let progressBackView = UIView().then { view in
    view.backgroundColor = .gray300
    view.layer.cornerRadius = Metric.progressHeight / 2.0
    view.layer.masksToBounds = true
  }
  private let progressBarView = UIView().then { view in
    view.backgroundColor = .systemGreen
  }
  private let flagView = UIView().then { view in
    view.backgroundColor = .systemRed
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
  
  private var isLayoutSubviews = true
  override func layoutSubviews() {
    super.layoutSubviews()
    
    if self.isLayoutSubviews {
      self.isLayoutSubviews = false
      let fullTime = self.progressBackView.bounds.width * 0.8
      self.flagView.snp.makeConstraints { make in
        make.centerX.equalTo(fullTime)
      }
    }
  }
  
  
  
  // MARK: - Interface
  
  func setData(_ runTime: Int) {
    let sumRunTimeHour = runTime / 60
    let sumRunTimeMin = runTime % 60
    let sumRunTimeText = String(format: "%d시간 %02d분", sumRunTimeHour, sumRunTimeMin)
    self.runTimeLabel.text = sumRunTimeText
    
    DispatchQueue.main.asyncAfter(
      deadline: .now() + 0.2,
      execute: { [weak self] in
        guard let self = self else { return }
        let workBaseHour = (AppManager.shared.settingData?.workBaseHour ?? 40) * 60
        let percent = CGFloat(Int((CGFloat(runTime) / CGFloat(workBaseHour)) * 100.0)) / 100.0
        let labelWidth = self.runTimeLabel.bounds.width
        let backWidth = self.progressBackView.bounds.width
        let fullTime = backWidth * 0.8
        let progress = fullTime * percent
        
        UIView.animate(
          withDuration: 3.0,
          delay: .zero,
          options: .curveEaseInOut,
          animations: {
            let progressWdith: CGFloat
            if progress <= backWidth {
              progressWdith = progress
              
            } else {
              progressWdith = backWidth
            }
            
            self.progressBarView.snp.updateConstraints { make in
              make.width.equalTo(progressWdith)
            }
            self.layoutIfNeeded()
          }
        )
        
        
        UIView.animate(
          withDuration: 2.7,
          delay: 0.3,
          options: .curveEaseInOut,
          animations: {
            let labelOffset: CGFloat
            if progress < (labelWidth / 2.0) {
              labelOffset = 0.0
              
            } else if progress > (backWidth - (labelWidth / 2.0)) {
              labelOffset = backWidth - labelWidth
              
            } else {
              labelOffset = progress - (labelWidth / 2.0)
            }
            
            self.runTimeLabel.snp.updateConstraints { make in
              make.leading.equalTo(self.progressBackView).offset(labelOffset)
            }
            self.layoutIfNeeded()
          }
        )
      }
    )
  }
  
  
  
  // MARK: - UI
  
  private func setAttribute() {
    
    [self.runTimeLabel, self.progressBackView]
      .forEach(self.addSubview(_:))
    
    [self.progressBarView, self.flagView]
      .forEach(self.progressBackView.addSubview(_:))
  }
  
  private func setConstraint() {
    self.runTimeLabel.snp.makeConstraints { make in
      make.leading.equalTo(self.progressBackView)
      make.top.equalToSuperview().offset(24.0)
    }
    
    self.progressBackView.snp.makeConstraints { make in
      make.top.equalTo(self.runTimeLabel.snp.bottom).offset(6.0)
      make.leading.trailing.bottom.equalToSuperview().inset(24.0)
      make.height.equalTo(Metric.progressHeight)
    }
    
    self.progressBarView.snp.makeConstraints { make in
      make.top.leading.bottom.equalToSuperview()
      make.width.equalTo(0.0)
    }
    
    self.flagView.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview()
      make.width.equalTo(2.0)
    }
  }
  
  private struct Metric {
    static let progressHeight: CGFloat = 12.0
  }
}
