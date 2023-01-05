//
//  Extension+UIViewController.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/05.
//

import UIKit

import UPsKit

extension UIViewController {
    
    func alertDatePiker(title: String? = nil, message: String? = nil, style: UIAlertController.Style = .alert, actionTitle: String, cancel: String, handler: ((Date) -> Void)? = nil, completion: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = NSLocale(localeIdentifier: "ko_KO") as Locale
        alert.view.addSubview(datePicker)
        
        let height : NSLayoutConstraint = NSLayoutConstraint(item: alert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.1, constant: 300)
        alert.view.addConstraint(height)
        
        
        let action = UIAlertAction(title: actionTitle, style: .default) { _ in
            handler?(datePicker.date)
        }
        alert.addAction(action)
        
        let cancel = UIAlertAction(title: cancel, style: .cancel)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: completion)
    }
}
