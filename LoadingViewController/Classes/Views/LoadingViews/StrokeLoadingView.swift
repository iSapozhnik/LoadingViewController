//
//  StrokeLoadingView.swift
//  LoadingControllerDemo
//
//  Created by Sapozhnik Ivan on 28.06.16.
//  Copyright © 2016 Sapozhnik Ivan. All rights reserved.
//

import UIKit

class StrokeLoadingView: LoadingView, Animatable {

	var activity = StrokeActivityView()

	override init(frame: CGRect) {
		super.init(frame: frame)
		defaultInitializer()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		defaultInitializer()
	}
	
	fileprivate func defaultInitializer() {
		let size = CGSize(width: 34, height: 34)
		activity.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		addSubview(activity)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		activity.center = CGPoint(x: bounds.midX, y: bounds.midY)
	}
	
	func startAnimating() {
		
		let delay = 0.0 * Double(NSEC_PER_SEC)
		let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
		DispatchQueue.main.asyncAfter(deadline: time, execute: {
			self.activity.animating = true
		})
	
	}
	
	func stopAnimating() {
		activity.animating = false
	}
	
}
