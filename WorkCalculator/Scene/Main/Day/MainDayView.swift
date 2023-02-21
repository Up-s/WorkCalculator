//
//  MainDayView.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/02/21.
//

import UIKit

import RxSwift
import SnapKit
import Then
import UPsKit

final class MainDayView: BaseView, MainViewProtocol {
  
  // MARK: - Property
  
  let navigationView: BaseNavigationView = BaseNavigationView(.none(0.0))
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
  private let infoView = MainDayInfoView()
  
  
  private let disposeBag = DisposeBag()
  
  
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
  
  var runTime: Binder<Int> {
    return Binder(self) { view, runTime in
      self.infoView.setData(runTime)
//      let max = (AppManager.shared.settingData?.workBaseHour ?? 40) * 60
//
//      let sumRunTimeHour = runTime / 60
//      let sumRunTimeMin = runTime % 60
//      let sumRunTimeText = String(format: "%d시간 %02d분", sumRunTimeHour, sumRunTimeMin)
//      let keyword = "[\(String(max / 60))시간]"
//      let totalText = sumRunTimeText + "\n" + keyword
//      let attributedText = NSMutableAttributedString.make(
//        text: totalText,
//        keyword: keyword,
//        keywordFont: .systemFont(ofSize: 16.0),
//        keywordColor: .gray900
//      )
//      view.totalSumUnitView.subLabel.attributedText = attributedText
//
//      let remained = max - runTime
//      let remainedHour = remained / 60
//      let remainedMin = remained % 60
//      let remainedText = String(format: "%d시간 %02d분", remainedHour, remainedMin)
//      view.remainedSumUnitView.subLabel.text = remainedText
    }
  }
  
  var blockViewModels: Binder<[MainBlockViewModel]> {
    return Binder(self) { view, blockViewModels in
//      blockViewModels
//        .compactMap { blockViewModel -> MainWeekBlockView? in
//          let blockView = MainWeekBlockView()
//
//          blockView.dayLabel.text = blockViewModel.inBlock.weekday.ko
//
//          blockView.startButton.rx.tap
//            .bind(to: blockViewModel.input.startDidTap)
//            .disposed(by: view.disposeBag)
//
//          blockView.endButton.rx.tap
//            .bind(to: blockViewModel.input.endDidTap)
//            .disposed(by: view.disposeBag)
//
//          blockView.restButton.rx.tap
//            .bind(to: blockViewModel.input.restDidTap)
//            .disposed(by: view.disposeBag)
//
//
//          blockViewModel.output.startTime
//            .toHourMin()
//            .bind(to: blockView.startButton.rx.title())
//            .disposed(by: view.disposeBag)
//
//          blockViewModel.output.endTime
//            .toHourMin()
//            .bind(to: blockView.endButton.rx.title())
//            .disposed(by: view.disposeBag)
//
//          blockViewModel.output.restTime
//            .toHourMin()
//            .bind(to: blockView.restButton.rx.title())
//            .disposed(by: view.disposeBag)
//
//          blockViewModel.output.runTime
//            .toRestHourMin()
//            .bind(to: blockView.runTimeLabel.rx.text)
//            .disposed(by: view.disposeBag)
//
//          blockViewModel.output.runTime
//            .map { time -> UIColor in
//              return time >= 0 ? UIColor.gray900 : UIColor.systemRed
//            }
//            .bind(to: blockView.runTimeLabel.rx.textColor)
//            .disposed(by: view.disposeBag)
//
//
//          return blockView
//        }
//        .enumerated()
//        .forEach { index, blockView in
//          view.contentsStackView.insertArrangedSubview(blockView, at: index)
//        }
    }
  }
  
  
  
  
  
  // MARK: - UI
  
  private func setAttribute() {
    self.backgroundColor = .light
    
    self.navigationView.titleLabel.text = "칼퇴 계산기"
    
    [self.changeViewButton, self.refreshButton, self.histortButton, self.settingButton].forEach { view in
      self.navigationView.addNavigationRightStackView(view)
    }
    
    
    
    self.addSubview(self.contentsScrollView)
    
    self.contentsScrollView.addSubview(self.contentsStackView)
    
    [self.infoView]
      .forEach(self.contentsStackView.addArrangedSubview(_:))
  }
  
  private func setConstraint() {
    let guide = self.safeAreaLayoutGuide
    
    self.contentsScrollView.snp.makeConstraints { make in
      make.top.equalTo(self.navigationView.snp.bottom)
      make.leading.trailing.bottom.equalTo(guide)
    }
    
    self.contentsStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.width.equalToSuperview()
    }
  }
}
