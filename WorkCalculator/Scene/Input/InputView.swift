//
//  InputView.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/02/02.
//

import UIKit

import SnapKit
import Then
import UPsKit

final class InputView: BaseView {
  
  // MARK: - Property
  
  let segmentedControl = UISegmentedControl(items: InputType.allCases.map { $0.title }).then { view in
    view.backgroundColor = .gray200
    view.selectedSegmentIndex = 0
    let font = UIFont.boldSystemFont(ofSize: 12.0)
    view.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
  }
  private let contentsStackView = UPsStackView(axis: .vertical, spacing: 24.0)
  let titleLabel = UILabel().then { view in
    view.textColor = .gray900
    view.textAlignment = .center
    view.font = .boldSystemFont(ofSize: 30.0)
    view.backgroundColor = .gray200
    view.layer.cornerRadius = 8.0
    view.layer.masksToBounds = true
  }
  private let vInput = UIView()
  let pickerView = InputPickerView().then { view in
    view.backgroundColor = .red
  }
  let padView = InputPadView().then { view in
    view.backgroundColor = .blue
  }
  let sliderView = InputSliderView().then { view in
    view.backgroundColor = .green
  }
  let buttonView = InputButtonView()
  
  
  
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
  
  @objc private func didTap(_ sender: UISegmentedControl) {
    self.setInputView(sender.selectedSegmentIndex)
  }
  
  private func setInputView(_ index: Int) {
    let view: UIView
    switch index {
    case 0: view = self.pickerView
    case 1: view = self.padView
    case 2: view = self.sliderView
    default: fatalError()
    }
    
    UIView.transition(
      with: self.vInput,
      duration: 1.0,
      options: .transitionFlipFromLeft,
      animations: { [weak self] in
        guard let self = self else { return }
        
        [self.pickerView, self.padView, self.sliderView].forEach { view in
          view.removeFromSuperview()
        }
        
        self.vInput.addSubview(view)
        view.snp.makeConstraints { make in
          make.edges.equalToSuperview()
        }
      }
    )
  }
  
  
  
  // MARK: - UI
  
  private func setAttribute() {
    self.backgroundColor = .dark.withAlphaComponent(0.5)
    
    self.segmentedControl.addTarget(self, action: #selector(self.didTap(_:)), for: .valueChanged)
    
    
    
    [self.segmentedControl, self.contentsStackView]
      .forEach(self.addSubview(_:))
    
    [self.titleLabel, self.vInput, self.buttonView]
      .forEach(self.contentsStackView.addArrangedSubview(_:))
    
    self.setInputView(0)
  }
  
  private func setConstraint() {
    self.segmentedControl.snp.makeConstraints { make in
      make.trailing.equalTo(self.contentsStackView)
      make.bottom.equalTo(self.contentsStackView.snp.top).offset(-16.0)
    }
    
    self.contentsStackView.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.width.equalTo(280.0)
    }
    
    self.titleLabel.snp.makeConstraints { make in
      make.height.equalTo(40)
    }
    
    self.vInput.snp.makeConstraints { make in
      make.height.equalTo(280.0)
    }
  }
}
