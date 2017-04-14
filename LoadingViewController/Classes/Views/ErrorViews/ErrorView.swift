//
//  ErrorView.swift
//  Pods
//
//  Created by Sapozhnik Ivan on 29.06.16.
//
//

import UIKit

public enum ErrorViewStyle {
	case simple
}

class ErrorView: UIView {

	var action: ActionHandler?
	
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
	var image: UIImage? {
		didSet {
			didSetImage()
		}
	}
	var actionTitle: String? {
		didSet {
			didSetActionTitle()
		}
	}
	
	static func viewWithStyle(_ style: ErrorViewStyle, actionHandler:ActionHandler? = nil) -> ErrorView {
		
		switch style {
		case .simple:
			let errorView = SimpleErrorView.loadFromNib()
			errorView.action = actionHandler
			return errorView
		}
	}
	
	func didSetTitle() {}
	func didSetMessage() {}
	func didSetImage() {}
	func didSetAction() {}
	func didSetActionTitle() {}
}
