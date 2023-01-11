//
//  ProgressView.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/11.
//

import UIKit

final class ProgressView: UIView {
    
    private let circleLayer: CAShapeLayer = CAShapeLayer()
    
    var value: Int = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let startAngle: CGFloat = (-(.pi) / 2)
        let endAngle: CGFloat = (CGFloat(((self.value % 100) + 1)) / 100) * (.pi * 2)
        let radius = (self.frame.width / 2 * 0.8)
        
        let interval = self.value / 100
        switch interval.isMultiple(of: 2) {
        case true:
            UIColor.gray400.set()
            
        case false:
            UIColor.gray500.set()
        }
        
        let path = UIBezierPath()
        path.lineWidth = 10
        path.addArc(withCenter: center,
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: startAngle + endAngle,
                    clockwise: true)
        path.stroke()
    }
}
