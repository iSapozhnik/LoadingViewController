//
//  IndicatorLoadingView.swift
//  LoadingControllerDemo
//
//  Created by Sapozhnik Ivan on 23.06.16.
//  Copyright © 2016 Sapozhnik Ivan. All rights reserved.
//

import UIKit

enum IndicatorLoadingViewStyle {
	case Small
	case Big
	case SmallTitle
	case BigTitle
}

class IndicatorLoadingView: LoadingView {

	var activity = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
	var titleLabel: UILabel?
	var style = IndicatorLoadingViewStyle.Big
	
	init(style: IndicatorLoadingViewStyle) {
		super.init(frame: CGRectZero)
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
	
	private func defaultInitializer() {
		
		switch style {
		case .Big: bigActivity()
		case .Small: smallActivity()
		case .SmallTitle: smallTitle()
		case .BigTitle: bigTitle()
		}
	}
	
	private func smallActivity() {
		activity = UIActivityIndicatorView(activityIndicatorStyle: .White)
		addActivity()
	}
	
	private func bigActivity() {
		activity = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
		addActivity()
	}
	
	private func defaultTitleLabel() {
		titleLabel = UILabel(frame: CGRectMake(0,0,100,44))
		titleLabel?.textAlignment = .Center
		titleLabel?.textColor = UIColor.lightGrayColor()
		addSubview(titleLabel!)
	}
	
	private func smallTitle() {
		smallActivity()
		addActivity()
		defaultTitleLabel()
	}
	
	private func bigTitle() {
		bigActivity()
		addActivity()
		defaultTitleLabel()
	}
	
	private func addActivity() {
		activity.startAnimating()
		activity.color = UIColor.darkGrayColor()
		addSubview(activity)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		activity.center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
		titleLabel?.center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds) + 40)
	}
	
	override func didSetTitle() {
		titleLabel?.text = self.title!
	}

}
