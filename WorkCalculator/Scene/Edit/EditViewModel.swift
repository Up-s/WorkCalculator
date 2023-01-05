//
//  EditViewModel.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/05.
//

import Foundation

import RxCocoa
import RxSwift
import UPsKit

final class EditViewModel: BaseViewModel {
    
    struct Input {
        let unitViewModelList = BehaviorRelay<[EditUnitViewModel]>(value: [])
    }
    
    struct Output {
    }
    
    // MARK: - Property
    
    let input = Input()
    let output = Output()
    
    
    
    
    // MARK: - Interface
    
    init() {
        super.init()
        
        
        
        
    }
}
