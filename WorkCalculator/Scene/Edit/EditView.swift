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

final class EditView: BaseView {
    
    // MARK: - Property
    
    private let contentsScrollView = UIScrollView()
    private let contentsStackView = UPsStackView(axis: .vertical, spacing: 32.0)
    private let titleLabel = UILabel().then { view in
        view.text = "칼퇴 계산기"
        view.textColor = .gray900
        view.textAlignment = .center
        view.font = .boldSystemFont(ofSize: 40.0)
    }
    
    var timeBlockViews: [EditTimeBlockView] = []
    var timeBlockViewModels: [EditTimeBlockViewModel] = []
    
    private let sumUnitStackView = UPsStackView(axis: .horizontal, distribution: .fillEqually, spacing: 16.0)
    let totalSumUnitView = EditSumUnitView().then { view in
        view.titleLabel.text = "총 근무시간"
    }
    let remainedSumUnitView = EditSumUnitView().then { view in
        view.titleLabel.text = "남은 근무시간"
    }
    let refreshButton = UIButton().then { view in
        view.setTitle("갱신", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = .boldSystemFont(ofSize: 20.0)
        view.backgroundColor = .systemBlue
    }
    let settingButton = UIButton().then { view in
        view.setTitle("설정", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = .boldSystemFont(ofSize: 20.0)
        view.backgroundColor = .systemGreen
    }
    
    private let disposeBag = DisposeBag()
    
    
    
    // MARK: - Life Cycle
    
    override init() {
        super.init()
        
        self.setAttribute()
        self.setConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Interface
    
    func setData(_ sumRunTime: Int) {
        let max = 40 * 60
        
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
    
    
    
    // MARK: - UI
    
    func createUnitView(_ blockViewModels: [EditTimeBlockViewModel]) {
        blockViewModels
            .compactMap { timeBlockViewModel -> EditTimeBlockView? in
                let weekday = timeBlockViewModel.weekday
                
                let isSelect = AppManager.shared.settingData?.days.contains(weekday) ?? false
                guard isSelect else { return nil }
                
                let timeBlockView = EditTimeBlockView(weekday)
                
                timeBlockView.startTimeButton.rx.tap
                    .bind(to: timeBlockViewModel.input.startDidTap)
                    .disposed(by: self.disposeBag)
                
                timeBlockView.endTimeButton.rx.tap
                    .bind(to: timeBlockViewModel.input.endDidTap)
                    .disposed(by: self.disposeBag)
                
                timeBlockView.restTimeButton.rx.tap
                    .bind(to: timeBlockViewModel.input.restDidTap)
                    .disposed(by: self.disposeBag)
                
                
                timeBlockViewModel.output.startTime
                    .bind(to: timeBlockView.startTimeButton.rx.title())
                    .disposed(by: self.disposeBag)
                
                timeBlockViewModel.output.endTime
                    .bind(to: timeBlockView.endTimeButton.rx.title())
                    .disposed(by: self.disposeBag)
                
                timeBlockViewModel.output.restTime
                    .bind(to: timeBlockView.restTimeButton.rx.title())
                    .disposed(by: self.disposeBag)
                
                timeBlockViewModel.output.runTime
                    .bind(to: timeBlockView.runTimeLabel.rx.text)
                    .disposed(by: self.disposeBag)
                
                return timeBlockView
            }
            .enumerated()
            .forEach { index, view in
                self.contentsStackView.insertArrangedSubview(view, at: index + 1)
            }
    }
    
    
    
    
    
    private func setAttribute() {
        self.backgroundColor = .light
        
        
        
        self.addSubview(self.contentsScrollView)
        
        self.contentsScrollView.addSubview(self.contentsStackView)
        
        [self.titleLabel]
            .forEach(self.contentsStackView.addArrangedSubview(_:))
        
        [self.sumUnitStackView, self.refreshButton, settingButton]
            .forEach(self.contentsStackView.addArrangedSubview(_:))
        
        [self.totalSumUnitView, self.remainedSumUnitView]
            .forEach(self.sumUnitStackView.addArrangedSubview(_:))
    }
    
    private func setConstraint() {
        let guide = self.safeAreaLayoutGuide
        
        self.contentsScrollView.snp.makeConstraints { make in
            make.edges.equalTo(guide)
        }
        
        self.contentsStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.edges.equalToSuperview().inset(24.0)
        }
        
        [self.refreshButton, self.settingButton].forEach { view in
            view.snp.makeConstraints { make in
                make.height.equalTo(48.0)
            }
        }
    }
}
