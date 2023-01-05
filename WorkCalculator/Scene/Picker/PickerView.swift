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
    
    private let contentsStackView = UPsStackView(axis: .vertical, margin: UIEdgeInsets(all: 16.0)).then { view in
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
    private let buttonStackView = UPsStackView(axis: .horizontal, distribution: .fillEqually, spacing: 8.0)
    let cancelButton = UIButton().then { view in
        view.setTitle("취소", for: .normal)
        view.setTitleColor(.gray600, for: .normal)
        view.titleLabel?.font = .boldSystemFont(ofSize: 20.0)
    }
    let okButton = UIButton().then { view in
        view.setTitle("선택", for: .normal)
        view.setTitleColor(.gray900, for: .normal)
        view.titleLabel?.font = .boldSystemFont(ofSize: 20.0)
    }
    
    private let hourList: [String] = { (0...24).map { String($0) } }()
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
        self.backgroundColor = .black.withAlphaComponent(0.4)
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        
        
        
        self.addSubview(self.contentsStackView)
        
        [self.titleLabel, self.pickerView, self.buttonStackView]
            .forEach(self.contentsStackView.addArrangedSubview(_:))
        
        [self.cancelButton, self.okButton]
            .forEach(self.buttonStackView.addArrangedSubview(_:))
    }
    
    private func setConstraint() {
        let guide = self.safeAreaLayoutGuide
        
        self.contentsStackView.snp.makeConstraints { make in
            make.centerY.equalTo(guide)
            make.leading.trailing.equalToSuperview().inset(24.0)
        }
        
        self.pickerView.snp.makeConstraints { make in
            make.height.equalTo(240.0)
        }
        
        self.buttonStackView.snp.makeConstraints { make in
            make.height.equalTo(48.0)
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
