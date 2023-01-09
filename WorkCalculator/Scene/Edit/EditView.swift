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
    
    let resetButton = UIButton().then { view in
        view.setTitle("리셋", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = .systemBlue
        view.titleLabel?.font = .boldSystemFont(ofSize: 20.0)
    }
    
    private let disposeBag = DisposeBag()
    
    
    
    // MARK: - Life Cycle
    
    override init() {
        super.init()
        
        self.createUnitView()
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
    
    private func createUnitView() {
        let days: [DateManager.Day] = [.mon, .tue, .wed, .thu, .fri]
        days.forEach { day in
            let timeBlockView = EditTimeBlockView(day)
            let timeBlockViewModel = EditTimeBlockViewModel(day)
            
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
            
            
            self.timeBlockViews.append(timeBlockView)
            self.timeBlockViewModels.append(timeBlockViewModel)
        }
    }
    
    private func setAttribute() {
        self.backgroundColor = .light
        
        
        
        self.addSubview(self.contentsScrollView)
        
        self.contentsScrollView.addSubview(self.contentsStackView)
        
        [self.titleLabel]
            .forEach(self.contentsStackView.addArrangedSubview(_:))
        
        self.timeBlockViews
            .forEach(self.contentsStackView.addArrangedSubview(_:))
        
        [self.sumUnitStackView, self.resetButton]
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
        
        self.resetButton.snp.makeConstraints { make in
            make.height.equalTo(48.0)
        }
    }
}
