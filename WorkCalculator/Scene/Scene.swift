//
//  Scene.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/05.
//

import UIKit
import UPsKit

enum Scene: SceneProtocol {
    
    case splash
    case edit
    case picker(PickerViewModel)
    
    
    var target: UIViewController {
        switch self {
        case .splash:
            return SplashViewController()
            
        case .edit:
            return EditViewController()
            
        case .picker(let viewModel):
            return PickerViewController(viewModel)
            
        }
    }
}