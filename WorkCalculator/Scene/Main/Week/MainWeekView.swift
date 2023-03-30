//
//  MainWeekView.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/05.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then
import UPsKit

final class MainWeekView: BaseView, MainViewProtocol {
  
  // MARK: - Property
  
  let navigationView: BaseNavigationView = BaseNavigationView(.none).then { view in
    view.titleLabel.text = "칼퇴 계산기"
  }
  let changeViewButton = UIButton().then { view in
    let image = UIImage.sfConfiguration(name: "rectangle.portrait.on.rectangle.portrait", color: .systemBlue)
    view.setImage(image, for: .normal)
  }
  let refreshButton = UIButton().then { view in
    let image = UIImage.sfConfiguration(name: "icloud.and.arrow.down", color: .systemBlue)
    view.setImage(image, for: .normal)
  }
  let histortButton = UIButton().then { view in
    let image = UIImage.sfConfiguration(name: "rectangle.stack", color: .systemBlue)
    view.setImage(image, for: .normal)
  }
  let settingButton = UIButton().then { view in
    let image = UIImage.sfConfiguration(name: "gearshape", color: .systemBlue)
    view.setImage(image, for: .normal)
  }
  
  private let contentsScrollView = UIScrollView().then { view in
    view.showsVerticalScrollIndicator = false
  }
  private let contentsStackView = UPsStackView(axis: .vertical, spacing: 32.0)
  private let infoView = MainWeekInfoView()
  private let sumUnitStackView = UPsStackView(axis: .horizontal, distribution: .fillEqually, spacing: 16.0)
  let totalSumUnitView = MainWeekSumUnitView().then { view in
    view.titleLabel.text = "총 근무시간"
  }
  let remainedSumUnitView = MainWeekSumUnitView().then { view in
    view.titleLabel.text = "남은 근무시간"
  }
  
  private let disposeBag = DisposeBag()
  
  
  
  // MARK: - Life Cycle
  
  override init() {
    super.init()
    
    self.setNavigation()
    self.setNavigationButton()
    self.setAttribute()
    self.setConstraint()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  // MARK: - Interface
  
  var weekPayTouchDown: Observable<Void>?
  var weekPayTouchOut: Observable<Void>?
  
  var weekPay: Binder<String> {
    return Binder(self) { _, _ in
      
    }
  }
  
  var blockViewModels: Binder<[MainBlockViewModel]> {
    return Binder(self) { view, blockViewModels in
      blockViewModels
        .compactMap { blockViewModel -> MainWeekBlockView? in
          let blockView = MainWeekBlockView()
          
          blockView.dayLabel.text = blockViewModel.inBlock.weekday.ko
          
          blockView.startButton.rx.tap
            .bind(to: blockViewModel.input.startDidTap)
            .disposed(by: view.disposeBag)
          
          blockView.endButton.rx.tap
            .bind(to: blockViewModel.input.endDidTap)
            .disposed(by: view.disposeBag)
          
          blockView.restButton.rx.tap
            .bind(to: blockViewModel.input.restDidTap)
            .disposed(by: view.disposeBag)
          
          
          Observable
            .combineLatest(blockViewModel.output.startTime, blockViewModel.output.endTime) { start, end -> String in
              switch (start, end) {
              case let(x, y) where x != nil && y == nil :
                return "현재 근무시간"
                
              default:
                return "일일 근무시간"
              }
            }
            .bind(to: blockView.runTimeInfoLabel.rx.text)
            .disposed(by: self.disposeBag)
          
          blockViewModel.output.startTime
            .toHourMin()
            .bind(to: blockView.startButton.rx.title())
            .disposed(by: view.disposeBag)
          
          blockViewModel.output.endTime
            .toHourMin()
            .bind(to: blockView.endButton.rx.title())
            .disposed(by: view.disposeBag)
          
          blockViewModel.output.restTime
            .toHourMin()
            .bind(to: blockView.restButton.rx.title())
            .disposed(by: view.disposeBag)
          
          blockViewModel.output.runTime
            .toRestHourMin()
            .bind(to: blockView.runTimeLabel.rx.text)
            .disposed(by: view.disposeBag)
          
          blockViewModel.output.runTime
            .map { time -> UIColor in
              return time >= 0 ? UIColor.gray900 : UIColor.systemRed
            }
            .bind(to: blockView.runTimeLabel.rx.textColor)
            .disposed(by: view.disposeBag)
          
          
          return blockView
        }
        .enumerated()
        .forEach { index, blockView in
          view.contentsStackView.insertArrangedSubview(blockView, at: index)
        }
    }
  }
  
  var runTime: Binder<Int> {
    return Binder(self) { view, runTime in
      let max = (AppManager.shared.settingData?.workBaseHour ?? 40) * 60
      
      let sumRunTimeHour = runTime / 60
      let sumRunTimeMin = runTime % 60
      let sumRunTimeText = String(format: "%d시간 %02d분", sumRunTimeHour, sumRunTimeMin)
      let keyword = "[\(String(max / 60))시간]"
      let totalText = sumRunTimeText + "\n" + keyword
      let attributedText = NSMutableAttributedString.make(
        text: totalText,
        keyword: keyword,
        keywordFont: .systemFont(ofSize: 16.0),
        keywordColor: .gray900
      )
      view.totalSumUnitView.subLabel.attributedText = attributedText
      
      let remained = max - runTime
      let remainedHour = remained / 60
      let remainedMin = remained % 60
      let remainedText = String(format: "%d시간 %02d분", remainedHour, remainedMin)
      view.remainedSumUnitView.subLabel.text = remainedText
    }
  }
  
  var notionData: Binder<NotionModel?> {
    return Binder(self) { _, _ in
      
    }
  }
  
  
  
  // MARK: - UI
  
  private func setAttribute() {
    self.addSubview(self.contentsScrollView)
    
    [self.infoView, self.contentsStackView]
      .forEach(self.contentsScrollView.addSubview(_:))
    
    [self.sumUnitStackView]
      .forEach(self.contentsStackView.addArrangedSubview(_:))
    
    [self.totalSumUnitView, self.remainedSumUnitView]
      .forEach(self.sumUnitStackView.addArrangedSubview(_:))
  }
  
  private func setConstraint() {
    let guide = self.safeAreaLayoutGuide
    
    self.contentsScrollView.snp.makeConstraints { make in
      make.top.equalTo(self.navigationView.snp.bottom)
      make.leading.trailing.bottom.equalTo(guide)
    }
    
    self.infoView.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview().inset(24.0)
      make.width.equalToSuperview().inset(24.0)
    }
    
    self.contentsStackView.snp.makeConstraints { make in
      make.top.equalTo(self.infoView.snp.bottom).offset(20.0)
      make.leading.trailing.bottom.equalToSuperview().inset(24.0)
      make.width.equalToSuperview().inset(24.0)
    }
  }
}
