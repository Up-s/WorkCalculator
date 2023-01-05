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
    case main
    
    
    var target: UIViewController {
        switch self {
        case .splash:
            return SplashViewController()
            
        case .main:
            return ViewController()
            
        }
    }
}
