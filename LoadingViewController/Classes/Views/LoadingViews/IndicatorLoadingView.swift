//
//  IndicatorLoadingView.swift
//  LoadingControllerDemo
//
//  Created by Sapozhnik Ivan on 23.06.16.
//  Copyright © 2016 Sapozhnik Ivan. All rights reserved.
//

import UIKit

enum IndicatorLoadingViewStyle {
	case small
	case big
	case smallTitle
	case bigTitle
}

class IndicatorLoadingView: LoadingView {

	var activity = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
	var titleLabel: UILabel?
	var style = IndicatorLoadingViewStyle.big
	
	init(style: IndicatorLoadingViewStyle) {
		super.init(frame: CGRect.zero)
		self.style = style
		defaultInitializer()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		defaultInitializer()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		defaultInitializer()
	}
	
	fileprivate func defaultInitializer() {
		
		switch style {
		case .big: bigActivity()
		case .small: smallActivity()
		case .smallTitle: smallTitle()
		case .bigTitle: bigTitle()
		}
	}
	
	fileprivate func smallActivity() {
		activity = UIActivityIndicatorView(activityIndicatorStyle: .white)
		addActivity()
	}
	
	fileprivate func bigActivity() {
		activity = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
		addActivity()
	}
	
	fileprivate func defaultTitleLabel() {
		titleLabel = UILabel(frame: CGRect(x: 0,y: 0,width: 100,height: 44))
		titleLabel?.textAlignment = .center
		titleLabel?.textColor = UIColor.lightGray
		addSubview(titleLabel!)
	}
	
	fileprivate func smallTitle() {
		smallActivity()
		addActivity()
		defaultTitleLabel()
	}
	
	fileprivate func bigTitle() {
		bigActivity()
		addActivity()
		defaultTitleLabel()
	}
	
	fileprivate func addActivity() {
		activity.startAnimating()
		activity.color = UIColor.darkGray
		addSubview(activity)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		activity.center = CGPoint(x: bounds.midX, y: bounds.midY)
		titleLabel?.center = CGPoint(x: bounds.midX, y: bounds.midY + 40)
	}
	
	override func didSetTitle() {
		titleLabel?.text = self.title!
	}

}
