//
//  LoadingView.swift
//  LoadingControllerDemo
//
//  Created by Sapozhnik Ivan on 23.06.16.
//  Copyright © 2016 Sapozhnik Ivan. All rights reserved.
//

import UIKit

protocol Animatable {
	func startAnimating()
	func stopAnimating()
}

public enum LoadingViewStyle {
	case Indicator
	case Stroke
	case Multicolor
	case Custom
}

class LoadingView: UIView {

	var title: String? {
		didSet {
			didSetTitle()
		}
	}
	var message: String? {
		didSet {
			didSetMessage()
		}
	}
	
	static func viewWithStyle(style: LoadingViewStyle) -> LoadingView {
		switch style {
		case .Indicator:
			return IndicatorLoadingView(style: .SmallTitle)
		case .Stroke:
			let loadingView = StrokeLoadingView()
			loadingView.startAnimating()
			return loadingView
		case .Multicolor:
			let loadingView = MulticolorLoadingView()
			loadingView.startAnimating()
			return loadingView
		case .Custom:
			//TODO: fix this
			return UIView() as! LoadingView
		}
	}
	
	func didSetTitle() {}
	func didSetMessage() {}
	
}
