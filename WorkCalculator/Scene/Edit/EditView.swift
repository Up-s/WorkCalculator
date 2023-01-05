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
    private let contentsStackView = UPsStackView(axis: .vertical, spacing: 24.0)
    private let titleLabel = UILabel().then { view in
        view.text = "칼퇴 계산기"
        view.textColor = .gray900
        view.textAlignment = .center
        view.font = .boldSystemFont(ofSize: 40.0)
    }
    var unitViews: [EditUnitView] = []
    var unitViewModels: [EditUnitViewModel] = []
    
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
        
        
        
        self.addSubview(self.contentsScrollView)
        
        self.contentsScrollView.addSubview(self.contentsStackView)
        
        [self.titleLabel]
            .forEach(self.contentsStackView.addArrangedSubview(_:))
        
        self.unitViews
            .forEach(self.contentsStackView.addArrangedSubview(_:))
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
    }
}
