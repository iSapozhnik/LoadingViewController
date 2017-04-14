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
	case indicator
	case stroke
	case multicolor
	case custom
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
	
	static func viewWithStyle(_ style: LoadingViewStyle) -> LoadingView {
		switch style {
		case .indicator:
			return IndicatorLoadingView(style: .smallTitle)
		case .stroke:
			let loadingView = StrokeLoadingView()
			loadingView.startAnimating()
			return loadingView
		case .multicolor:
			let loadingView = MulticolorLoadingView()
			loadingView.startAnimating()
			return loadingView
		case .custom:
			//TODO: fix this
			return UIView() as! LoadingView
		}
	}
	
	func didSetTitle() {}
	func didSetMessage() {}
	
}
