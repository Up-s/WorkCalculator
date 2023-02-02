//
//  InputPickerView.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/02/02.
//

import UIKit

import SnapKit
import Then
import UPsKit

final class InputPickerView: BaseView {
  
  // MARK: - Property
  
  let pickerView = UIPickerView()
  
  private let hourList: [String] = { (0...24).map { String($0) } }()
  private let minList: [String] = { (0...59).map { String($0) } }()
  var selectHour: Int?
  var selectMin: Int?
  
  
  
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
  
  func setData(_ time: Int) {
    let hour = time / 60
    let min = time % 60
    
    self.pickerView.selectRow(hour, inComponent: 0, animated: true)
    self.pickerView.selectRow(min, inComponent: 1, animated: true)
  }
  
  
  
  // MARK: - UI
  
  private func setAttribute() {
    self.pickerView.dataSource = self
    self.pickerView.delegate = self
    
    
    
    self.addSubview(self.pickerView)
  }
  
  private func setConstraint() {
    self.pickerView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}



// MARK: - UIPickerViewDataSource

extension InputPickerView: UIPickerViewDataSource {
  
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



// MARK: - UIPickerViewDelegate

extension InputPickerView: UIPickerViewDelegate {
  
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
