//
//  EditView.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/05.
//

import UIKit

import RxSwift
import SnapKit
import Then
import UPsKit

final class EditView: BaseView, NavigationProtocol {
    
    // MARK: - Property
    
    var navigationView: BaseNavigationView
    
    private let contentsScrollView = UIScrollView().then { view in
        view.showsVerticalScrollIndicator = false
    }
    private let contentsStackView = UPsStackView(axis: .vertical, spacing: 32.0)
    
    private let infoView = EditInfoView()
    
    private let sumUnitStackView = UPsStackView(axis: .horizontal, distribution: .fillEqually, spacing: 16.0)
    let totalSumUnitView = EditSumUnitView().then { view in
        view.titleLabel.text = "총 근무시간"
    }
    let remainedSumUnitView = EditSumUnitView().then { view in
        view.titleLabel.text = "남은 근무시간"
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
    
    private let disposeBag = DisposeBag()
    
    
    
    // MARK: - Life Cycle
    
    override init() {
        self.navigationView = BaseNavigationView(.none(0.0))
        
        super.init()
        
        self.setNavigation()
        self.setAttribute()
        self.setConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Interface
    
    func setData(_ sumRunTime: Int) {
        let max = (AppManager.shared.settingData?.workBaseHour ?? 40) * 60
        
        let sumRunTimeHour = sumRunTime / 60
        let sumRunTimeMin = sumRunTime % 60
        let sumRunTimeText = String(format: "%d시간 %02d분", sumRunTimeHour, sumRunTimeMin)
        let keyword = String(max / 60) + "시간"
        let totalText = sumRunTimeText + "\n" + keyword
        let attributedText = NSMutableAttributedString.make(
            text: totalText,
            keyword: keyword,
            keywordFont: .systemFont(ofSize: 16.0),
            keywordColor: .gray900
        )
        self.totalSumUnitView.subLabel.attributedText = attributedText
        
        let remained = max - sumRunTime
        let remainedHour = remained / 60
        let remainedMin = remained % 60
        let remainedText = String(format: "%d시간 %02d분", remainedHour, remainedMin)
        self.remainedSumUnitView.subLabel.text = remainedText
    }
    
    func createUnitView(_ blockViewModels: [EditBlockViewModel]) {
        blockViewModels
            .compactMap { blockViewModel -> EditBlockView? in
                let blockView = EditBlockView()
                
                blockView.dayLabel.text = blockViewModel.inBlock.weekday.ko
                
                blockView.startButton.rx.tap
                    .bind(to: blockViewModel.input.startDidTap)
                    .disposed(by: self.disposeBag)
                
                blockView.endButton.rx.tap
                    .bind(to: blockViewModel.input.endDidTap)
                    .disposed(by: self.disposeBag)
                
                blockView.restButton.rx.tap
                    .bind(to: blockViewModel.input.restDidTap)
                    .disposed(by: self.disposeBag)
                
                
                blockViewModel.output.startTime
                    .toHourMin()
                    .bind(to: blockView.startButton.rx.title())
                    .disposed(by: self.disposeBag)
                
                blockViewModel.output.endTime
                    .toHourMin()
                    .bind(to: blockView.endButton.rx.title())
                    .disposed(by: self.disposeBag)
                
                blockViewModel.output.restTime
                    .toHourMin()
                    .bind(to: blockView.restButton.rx.title())
                    .disposed(by: self.disposeBag)
                
                blockViewModel.output.runTime
                    .toRestHourMin()
                    .bind(to: blockView.runTimeLabel.rx.text)
                    .disposed(by: self.disposeBag)
                
                blockViewModel.output.runTime
                    .map { time -> UIColor in
                        return time >= 0 ? UIColor.gray900 : UIColor.systemRed
                    }
                    .bind(to: blockView.runTimeLabel.rx.textColor)
                    .disposed(by: self.disposeBag)
                
                
                return blockView
            }
            .enumerated()
            .forEach { index, view in
                self.contentsStackView.insertArrangedSubview(view, at: index)
            }
    }
    
    
    
    // MARK: - UI
    
    private func setAttribute() {
        self.backgroundColor = .light
        
        self.navigationView.titleLabel.text = "칼퇴 계산기"
        
        [self.refreshButton, self.histortButton, self.settingButton].forEach { view in
            self.navigationView.addNavigationRightStackView(view)
        }
        
        
        
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
