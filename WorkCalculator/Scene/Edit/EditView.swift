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
    
    var unitViews: [EditUnitView] = []
    var unitViewModels: [EditUnitViewModel] = []
    
    private let sumUnitStackView = UPsStackView(axis: .horizontal, distribution: .fillEqually, spacing: 16.0)
    let totalSumUnitView = EditSumUnitView().then { view in
        view.titleLabel.text = "총 근무시간"
    }
    let remainedSumUnitView = EditSumUnitView().then { view in
        view.titleLabel.text = "남은 근무시간"
    }
    
    let resetButton = UIButton().then { view in
        view.setTitle("리셋", for: .normal)
        view.setTitleColor(.light, for: .normal)
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
            let unitView = EditUnitView(day)
            let unitViewModel = EditUnitViewModel(day)
            
            unitView.startTimeButton.rx.tap
                .bind(to: unitViewModel.input.startDidTap)
                .disposed(by: self.disposeBag)
            
            unitView.endTimeButton.rx.tap
                .bind(to: unitViewModel.input.endDidTap)
                .disposed(by: self.disposeBag)
            
            unitView.restTimeButton.rx.tap
                .bind(to: unitViewModel.input.restDidTap)
                .disposed(by: self.disposeBag)
            
            
            unitViewModel.output.startTime
                .bind(to: unitView.startTimeButton.rx.title())
                .disposed(by: self.disposeBag)
            
            unitViewModel.output.endTime
                .bind(to: unitView.endTimeButton.rx.title())
                .disposed(by: self.disposeBag)
            
            unitViewModel.output.restTime
                .bind(to: unitView.restTimeButton.rx.title())
                .disposed(by: self.disposeBag)
            
            unitViewModel.output.runTime
                .bind(to: unitView.runTimeLabel.rx.text)
                .disposed(by: self.disposeBag)
            
            
            self.unitViews.append(unitView)
            self.unitViewModels.append(unitViewModel)
        }
    }
    
    private func setAttribute() {
        self.backgroundColor = .light
        
        
        
        self.addSubview(self.contentsScrollView)
        
        self.contentsScrollView.addSubview(self.contentsStackView)
        
        [self.titleLabel]
            .forEach(self.contentsStackView.addArrangedSubview(_:))
        
        self.unitViews
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
