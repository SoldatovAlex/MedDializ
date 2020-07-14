//
//  ThermometrView.swift
//  MedDializ


import UIKit

final class ThermometerView: UIView {
    private let thermoLayer = CAShapeLayer()
    private let levelLayer = CAShapeLayer()
    private let maskLayer = CAShapeLayer()
    
    private let color = UIColor(displayP3Red: 90/255, green: 200/255, blue: 250/255, alpha: 1).cgColor
    private let color2 = UIColor(displayP3Red: 165/255, green: 91/255, blue: 97/255, alpha: 0.3).cgColor
    
    private var lineWidth: CGFloat {
        return bounds.width / 3
    }
    
    @IBInspectable var level: CGFloat = 1 {
        didSet {
            if level < 0.5 {
                thermoLayer.fillColor = UIColor.red.cgColor
            } else {
                thermoLayer.fillColor = UIColor.green.cgColor
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    private func setup() {
        layer.addSublayer(thermoLayer)
        layer.addSublayer(levelLayer)
        
        
        let width = bounds.width - lineWidth
        let height = bounds.height - lineWidth / 2
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: height-width, width: width, height: width))
        path.move(to: CGPoint(x: width / 2, y: height - width))
        path.addLine(to: CGPoint(x: width / 2, y: 10))
        thermoLayer.path = path.cgPath
        thermoLayer.strokeColor = color2
        
        thermoLayer.lineWidth = width / 3
        thermoLayer.position.x = lineWidth / 2
        thermoLayer.lineCap = CAShapeLayerLineCap.round
        
        maskLayer.path = thermoLayer.path
        maskLayer.lineWidth = thermoLayer.lineWidth
        maskLayer.lineCap = thermoLayer.lineCap
        maskLayer.position = thermoLayer.position
        maskLayer.strokeColor = thermoLayer.strokeColor
        maskLayer.lineWidth = thermoLayer.lineWidth - 6
        maskLayer.fillColor = nil
        
        buildLevelLayer()
        thermoLayer.fillColor = UIColor.red.cgColor
        levelLayer.mask = maskLayer
        
    }
    
    private func buildLevelLayer() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.midX, y: bounds.height))
        path.addLine(to: CGPoint(x: bounds.midX, y: 0))
        levelLayer.strokeColor = color
        levelLayer.path = path.cgPath
        levelLayer.lineWidth = bounds.width
        levelLayer.strokeEnd = level
    }
    
    func startAnimation(completion: @escaping () -> ()) {
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.level = 1
            completion()
        })
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 1
        animation.toValue = 0.3
        animation.duration = 2
        levelLayer.add(animation, forKey: "line")
        levelLayer.strokeEnd = 0.3
        CATransaction.commit()
        
    }
}
