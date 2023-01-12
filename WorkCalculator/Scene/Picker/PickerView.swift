//
//  PickerView.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/05.
//

import UIKit

import SnapKit
import Then
import UPsKit

final class PickerView: BaseView {
    
    // MARK: - Property
    
    private let contentsView = UIView()
    private let infoStackView = UPsStackView(axis: .vertical, margin: UIEdgeInsets(all: 16.0)).then { view in
        view.backgroundColor = .light
        view.layer.cornerRadius = 8.0
        view.layer.masksToBounds = true
    }
    let titleLabel = UILabel().then { view in
        view.textColor = .gray900
        view.textAlignment = .center
        view.font = .boldSystemFont(ofSize: 30.0)
    }
    let pickerView = UIPickerView()
    let inputButtonView = InputButtonView()
    
    private let hourList: [String] = { (0...23).map { String($0) } }()
    private let minList: [String] = { (0...59).map { String($0) } }()
    var selectHour: Int = 0
    var selectMin: Int = 0
    
    
    
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
    
    func setData() {
        let date = Date()
        let hour = date.hourInt()
        let min = date.minuteInt()
        
        self.selectHour = hour
        self.selectMin = min
        
        self.pickerView.selectRow(hour, inComponent: 0, animated: true)
        self.pickerView.selectRow(min, inComponent: 1, animated: true)
    }
    
    
    
    // MARK: - UI
    
    private func setAttribute() {
        self.backgroundColor = .dark.withAlphaComponent(0.4)
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        
        
        
        self.addSubview(self.contentsView)
        
        [self.infoStackView, self.inputButtonView]
            .forEach(self.contentsView.addSubview(_:))
        
        [self.titleLabel, self.pickerView]
            .forEach(self.infoStackView.addArrangedSubview(_:))
    }
    
    private func setConstraint() {
        let guide = self.safeAreaLayoutGuide
        
        self.contentsView.snp.makeConstraints { make in
            make.center.equalTo(guide)
            make.width.equalTo(280.0)
        }
        
        self.infoStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        self.inputButtonView.snp.makeConstraints { make in
            make.top.equalTo(self.infoStackView.snp.bottom).offset(16.0)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        self.pickerView.snp.makeConstraints { make in
            make.height.equalTo(240.0)
        }
    }
}


extension PickerView: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return self.hourList.count
        case 1: return self.minList.count
        default: fatalError()
        }
    }
}



extension PickerView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0: return self.hourList[row] + " 시"
        case 1: return self.minList[row] + " 분"
        default: fatalError()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0: self.selectHour = row
        case 1: self.selectMin = row
        default: fatalError()
        }
    }
}
