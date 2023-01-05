//
//  Extension+SceneCoordicator.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/05.
//

import UIKit

import UPsKit

extension SceneCoordinator {
    
    func alertDatePiker(title: String? = nil, message: String? = nil, style: UIAlertController.Style = .alert, actionTitle: String, cancel: String, handler: ((Date) -> Void)? = nil, completion: (() -> Void)? = nil) {
        self.currentVC.alertDatePiker(title: title, message: message, style: style, actionTitle: actionTitle, cancel: cancel, handler: handler, completion: completion)
    }
}
