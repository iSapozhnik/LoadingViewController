//
//  MulticolorLoadingView.swift
//  LoadingControllerDemo
//
//  Created by Sapozhnik Ivan on 28.06.16.
//  Copyright © 2016 Sapozhnik Ivan. All rights reserved.
//

import UIKit

class MulticolorActivityView: UIView {
	
	let defaultLineWidth: CGFloat = 2.0
	let defaultColor = UIColor.orange
	let defaultRoundTime = 1.5
	
	var colorArray = [UIColor.green, UIColor.red, UIColor.blue, UIColor.purple,]
	
	fileprivate var circleLayer = CAShapeLayer()
	fileprivate var strokeLineAnimation = CAAnimationGroup()
	fileprivate let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
	fileprivate let strokeColorAnimation = CAKeyframeAnimation(keyPath: "strokeColor")
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		initialSetup()
	}
	
	required internal init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initialSetup()
	}
	
	// MARK:- Public
	
	func startAnimating() {
		circleLayer.add(strokeLineAnimation, forKey: "strokeLineAnimation")
		circleLayer.add(rotationAnimation, forKey: "rotationAnimation")
		circleLayer.add(strokeColorAnimation, forKey: "strokeColorAnimation")
	}
	
	func stopAnimating() {
		circleLayer.removeAnimation(forKey: "strokeLineAnimation")
		circleLayer.removeAnimation(forKey: "rotationAnimation")
		circleLayer.removeAnimation(forKey: "strokeColorAnimation")
	}
	
	// MARK:- Private
	
	fileprivate func initialSetup() {
		self.layer.addSublayer(circleLayer)
		backgroundColor = .clear
		circleLayer.fillColor = nil
		circleLayer.lineWidth = defaultLineWidth
		circleLayer.lineCap = "round"
		
		updateAnimations()
	}
	
	fileprivate func updateAnimations() {
		
		// Stroke head
		let headAnimation = CABasicAnimation(keyPath: "strokeStart")
		headAnimation.beginTime = defaultRoundTime / 3.0
		headAnimation.fromValue = 0
		headAnimation.toValue = 1
		headAnimation.duration = 2 * defaultRoundTime / 3.0
		headAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		
		// Stroke tail
		let tailAnimation = CABasicAnimation(keyPath: "strokeEnd")
		tailAnimation.fromValue = 0
		tailAnimation.toValue = 1
		tailAnimation.duration = 2 * defaultRoundTime / 3.0
		tailAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		
		// Stroke line group
		strokeLineAnimation.duration = defaultRoundTime
		strokeLineAnimation.repeatCount = Float.infinity
		strokeLineAnimation.animations = [headAnimation, tailAnimation]
		
		// Rotation
		rotationAnimation.fromValue = 0
		rotationAnimation.toValue = 2 * Double.pi
		rotationAnimation.duration = defaultRoundTime
		rotationAnimation.repeatCount = Float.infinity
		
		// Color animation
		strokeColorAnimation.values = colorArray.map({$0.cgColor})
		strokeColorAnimation.keyTimes = keyTimes() as [NSNumber]
		strokeColorAnimation.calculationMode = kCAAnimationDiscrete;
		strokeColorAnimation.duration = Double(colorArray.count) * defaultRoundTime
		strokeColorAnimation.repeatCount = Float.infinity
	}
	
	fileprivate func colorValues() -> [CGColor] {
		var colors: [CGColor] = []
		for color in colorArray {
			colors.append(color.cgColor)
		}
		return colors
	}
	
	fileprivate func keyTimes() -> Array<Double> {
		var array: Array<Double> = []
		
		for (index, _) in colorArray.enumerated() {
			array.append(Double(index)/Double(colorArray.count))
		}
		array.append(1.0)
		return array
	}
	
	// MARK:- Layout
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		let center = CGPoint(x: bounds.midX, y: bounds.midY)
		let radius = min(self.bounds.size.width, self.bounds.size.height) / 2.0 - circleLayer.lineWidth / 2.0
		let startAngle = 0.0 as CGFloat
		let endAngle = CGFloat(2 * Double.pi)
		
		let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
		circleLayer.path = path.cgPath
		circleLayer.frame = bounds
	}
	
}
