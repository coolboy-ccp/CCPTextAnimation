//
//  GradientText.swift
//  CCPTextAnimation
//
//  Created by 储诚鹏 on 2019/1/31.
//  Copyright © 2019 储诚鹏. All rights reserved.
//

import UIKit

private let textAnimationDuration: TimeInterval = 5

class GradientText: UIView {
    private let gradientLayer = CAGradientLayer()
    private let gradientAnimationDuration: TimeInterval = 0.5
    private let textLayer = CAShapeLayer()
    private let text: String
    
    public static func animation(in view: UIView, origin: CGPoint, text: CCPTextAvaiable) {
        let textSize = text.bezierPath().cgPath.boundingBox.size
        let gt = GradientText(frame: CGRect(origin: origin, size: textSize), text: text.text)
        view.addSubview(gt)
    }
    
    public static func animation(in view: UIView, origin: CGPoint, texts: [CCPTextAvaiable]) {
        var offsetOrigin = origin
        var after: TimeInterval = 0
        for text in texts {
            DispatchQueue.main.asyncAfter(deadline: .now() + after) {
                let textSize = text.bezierPath().cgPath.boundingBox.size
                let gt = GradientText(frame: CGRect(origin: offsetOrigin, size: textSize), text: text.text)
                offsetOrigin.y += textSize.height + 20
                view.addSubview(gt)
            }
            after += textAnimationDuration
            
        }
        
    }
    
    init(frame: CGRect, text: CCPTextAvaiable) {
        self.text = text.text
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addGradient()
        addTextLayer()
        gradientLayer.mask = textLayer
    }
    
    private func addGradient() {
        let topColor = UIColor(red: 91 / 255, green: 255 / 255, blue: 91 / 255, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 255 / 255, green: 24 / 255, blue: 24 / 255, alpha: 1.0).cgColor
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.colors = [topColor, bottomColor]
        gradientLayer.frame = self.bounds
        gradientLayer.type = .axial
        self.layer.addSublayer(gradientLayer)
        gradientAnimation()
    }
    
    private func stringSize() -> CGSize {
        return textLayer.bounds.size
    }
    
    private func addTextLayer() {
        let textPath = text.bezierPath()
        textLayer.bounds = textPath.cgPath.boundingBox
        textLayer.position = gradientLayer.position
        textLayer.path = textPath.cgPath
        //是否垂直翻转
        textLayer.isGeometryFlipped = true
        textLayer.fillColor = nil
        textLayer.lineWidth = 1
        textLayer.strokeColor = UIColor.black.cgColor
        textAnimation()
    }
    
    private func textAnimation() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = textAnimationDuration
        animation.fromValue = 0
        animation.toValue = 1
        textLayer.add(animation, forKey: "textAnimation")
    }
    
    private func gradientAnimation() {
        let animation = CABasicAnimation(keyPath: "colors")
        animation.duration = gradientAnimationDuration
        animation.repeatCount = Float.infinity
        animation.autoreverses = true
        animation.toValue = colors()
        gradientLayer.add(animation, forKey: "gradientAnimation")
    }
    
    private func colors() -> [CGColor] {
        var colors = [CGColor]()
        for _ in 0 ... 9 {
            let color = UIColor(red: randomColorValue(), green: randomColorValue(), blue: randomColorValue(), alpha: 1.0)
            colors.append(color.cgColor)
        }
        return colors
    }
    
    private func randomColorValue() -> CGFloat {
        return CGFloat(arc4random_uniform(255) / 255)
    }
}
