//
//  MainDayBlockCollectionViewCell.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/02/23.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then
import UPsKit

final class MainDayBlockCollectionViewCell: UICollectionViewCell, CellIdentifiable {
  
  // MARK: - Property
  
  private let contentsStackView = UPsStackView(axis: .vertical, alignment: .center, spacing: 24.0)
  private let dayLabel = UILabel().then { view in
    view.backgroundColor = .gray200
    view.textAlignment = .center
    view.textColor = .gray900
    view.font = .boldSystemFont(ofSize: 80.0)
  }
  private let infoStackView = UPsStackView(axis: .horizontal, spacing: 8.0)
  private let runTimeInfoLabel = UILabel().then { view in
    view.text = "일일근무시간"
    view.textColor = .gray900
    view.font = .systemFont(ofSize: 16.0)
  }
  private let runTimeLabel = UILabel().then { view in
    view.textColor = .gray900
    view.font = .boldSystemFont(ofSize: 16.0)
  }
  let startButtonView = TimeButtonView(.start)
  let endButtonView = TimeButtonView(.end)
  let restButtonView = TimeButtonView(.rest)
  
  var disposeBag = DisposeBag()
  
  
  
  // MARK: - Life Cycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.setAttribute()
    self.setConstraint()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    self.disposeBag = DisposeBag()
  }
  
  
  
  // MARK: - Interface
  
  func setData(_ blockViewModel:  MainBlockViewModel) {
    self.dayLabel.text = blockViewModel.inBlock.weekday.ko
    
    self.startButtonView.button.rx.tap
      .bind(to: blockViewModel.input.startDidTap)
      .disposed(by: self.disposeBag)
    
    self.endButtonView.button.rx.tap
      .bind(to: blockViewModel.input.endDidTap)
      .disposed(by: self.disposeBag)
    
    self.restButtonView.button.rx.tap
      .bind(to: blockViewModel.input.restDidTap)
      .disposed(by: self.disposeBag)
    
    
    Observable
      .combineLatest(blockViewModel.output.startTime, blockViewModel.output.endTime) { start, end -> String in
        switch (start, end) {
        case let(x, y) where x != nil && y == nil :
          return "현재 근무시간"
          
        default:
          return "일일 근무시간"
        }
      }
      .bind(to: self.runTimeInfoLabel.rx.text)
      .disposed(by: self.disposeBag)
    
    blockViewModel.output.startTime
      .toHourMin()
      .bind(to: self.startButtonView.timeLabel.rx.text)
      .disposed(by: self.disposeBag)
    
    blockViewModel.output.endTime
      .toHourMin()
      .bind(to: self.endButtonView.timeLabel.rx.text)
      .disposed(by: self.disposeBag)
    
    blockViewModel.output.restTime
      .toHourMin()
      .bind(to: self.restButtonView.timeLabel.rx.text)
      .disposed(by: self.disposeBag)
    
    blockViewModel.output.runTime
      .toRestHourMin()
      .bind(to: self.runTimeLabel.rx.text)
      .disposed(by: self.disposeBag)
    
    blockViewModel.output.runTime
      .map { time -> UIColor in
        return time >= 0 ? UIColor.gray900 : UIColor.systemRed
      }
      .bind(to: self.runTimeLabel.rx.textColor)
      .disposed(by: self.disposeBag)
  }
  
  
  
  // MARK: - UI
  
  private func setAttribute() {
    self.contentView.backgroundColor = .gray200
    self.contentView.layer.cornerRadius = 4.0
    self.contentView.layer.masksToBounds = true
    
    
    
    self.contentView.addSubview(self.contentsStackView)
    
    [self.dayLabel, self.infoStackView, self.startButtonView, self.endButtonView, self.restButtonView]
      .forEach(self.contentsStackView.addArrangedSubview(_:))
    
    [self.runTimeInfoLabel, self.runTimeLabel]
      .forEach(self.infoStackView.addArrangedSubview(_:))
  }
  
  private func setConstraint() {
    self.contentsStackView.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }
}
