//
//  BaseLoadingViewController.swift
//  LoadingControllerDemo
//
//  Created by Sapozhnik Ivan on 23.06.16.
//  Copyright © 2016 Sapozhnik Ivan. All rights reserved.
//

import UIKit

// This extension should be used for testing purposes

extension UIViewController {
	public func delay(_ delay:Double, closure:@escaping ()->()) {
		DispatchQueue.main.asyncAfter(
			deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
	}
}

public enum ContentType: Int {
	case Undefined = 0
	case Empty
	case NoData
	case Failure
	case Content
	case Loading
}

let FromViewKey = "fromView"
let ToViewKey = "toView"
let AnimatedKey = "animated"
let ScreenKey = "screen"
let animationDuration: TimeInterval = 0.3;


typealias AnimationDict = Dictionary<String, AnyObject>
public typealias ActionHandler = () -> ()

open class LoadingViewController: UIViewController {

	@IBOutlet open var contentView: UIView!
	
	open var lastError: NSError?
	var defaultLoadingColor = UIColor(colorLiteralRed: 250/255, green: 250/255, blue: 250/255, alpha: 1)
	open var loadingViewColor: UIColor?
	open var NoDataViewColor: UIColor?
	open var errorViewColor: UIColor?
	open var errorActionTitle: String? = NSLocalizedString("Try again", comment: "")
	
	var visibleContentType: ContentType = .Undefined
	var activeView: UIView?
	
	var animationQueue = Array<AnimationDict>()
	var currentAnimation: AnimationDict?
	
	open var customErrorTitle: String?
	open var customErrorMessage: String?
	
	open var errorTitle: String {
		get {
			return lastError?.localizedDescription ?? customErrorTitle ?? NSLocalizedString("Oops, something went wrong", comment: "")
		}
	}
	open var errorMessage: String {
		get {
			return lastError?.localizedFailureReason ?? customErrorMessage ?? NSLocalizedString("Please try again later", comment: "")
		}
	}
	open var errorIcon: UIImage?
	
	open var NoDataMessage: String = NSLocalizedString("No data available. Please, try another request.", comment: "")

	var contentViewAllwaysAvailabel: Bool = false
	
	//MARK:- Default views
	
	func defaultNoDataView() -> UIView {
		let view = NoDataView.viewWithStyle(NoDataViewStyle())
		view.backgroundColor = NoDataViewColor ?? loadingViewColor
		view.message = NoDataMessage
		return view
	}
	
	func defaultErrorView(_ action: ActionHandler? = nil) -> UIView {
		let view = ErrorView.viewWithStyle(errorViewStyle(), actionHandler: action)
		view.backgroundColor = errorViewColor ?? loadingViewColor
		view.title = errorTitle
		view.message = errorMessage
		view.image = errorIcon
		view.actionTitle = errorActionTitle
		return view
	}
	
	func defaultLoadingView() -> UIView {
		let view = LoadingView.viewWithStyle(loadingViewStyle())
		view.backgroundColor = loadingViewColor ?? defaultLoadingColor
		
		//TODO: add title, background image, etc.
		view.title = "Loading"
		return view
	}
	
	open func loadingViewStyle() -> LoadingViewStyle {
		return .indicator
	}
	
	open func errorViewStyle() -> ErrorViewStyle {
		return .simple
	}
	
	open func NoDataViewStyle() -> NoDataViewStyle {
		return .simple
	}

	open func showsErrorView() -> Bool {
		return true
	}
	
	open func showsNoDataView() -> Bool {
		return true
	}
	
	open func showsLoadingView() -> Bool {
		return true
	}
	
	func addView(_ viewToAdd: UIView) {
		view.addSubview(viewToAdd)
		viewToAdd.translatesAutoresizingMaskIntoConstraints = false
		let bindings = ["view": viewToAdd]
		view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[view]|", options: [.alignAllLeading, .alignAllTrailing], metrics: nil, views: bindings))
		view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [.alignAllTop, .alignAllBottom], metrics: nil, views: bindings))
		view.layoutIfNeeded()
	}
	
	func viewForScreen(_ contentType: ContentType, action: ActionHandler? = nil) -> UIView {
		switch contentType {
		case .Content:
			return contentView
		case .Failure:
			return defaultErrorView(action)
		case .Loading:
			return defaultLoadingView()
		case .NoData:
			return defaultNoDataView()
		case .Undefined, .Empty:
			let result = UIView()
			result.backgroundColor = .red
			return result
		}
	}
	
	// TODO: add ActionHandler support to handle 'Retry' tap on ErrorViews
	
	open func setVisibleScreen(_ contentType: ContentType, animated: Bool = true, actionHandler:ActionHandler? = nil) {
		if visibleContentType != contentType {
			visibleContentType = contentType
			let view = viewForScreen(visibleContentType, action: actionHandler)
			setActiveView(view, animated: animated)
		}
	}

	func setActiveView(_ viewToSet: UIView, animated: Bool) {
		if viewToSet != activeView {
			let oldView = activeView ?? nil
			activeView = viewToSet
			
			let animation = animationFormView(oldView, toView: viewToSet, contentType: visibleContentType, animated: animated)
			
			if animated {
				addAnimation(animation)
			} else {
				performAnimation(animation)
			}
		}
	}
	
	fileprivate func animationFormView(_ fromView: UIView?, toView: UIView, contentType: ContentType, animated: Bool) -> AnimationDict {
		var data = AnimationDict()
		data[FromViewKey] = fromView
		data[ToViewKey] = toView
		data[AnimatedKey] = animated as AnyObject
		data[ScreenKey] = contentType.rawValue as AnyObject
		return data
	}
	
	fileprivate func mergedAnimation(_ animation1: AnimationDict, animation2: AnimationDict) -> AnimationDict {
		var result: AnimationDict = [:]
		
		let fromView = animation1[FromViewKey]
		let toView = animation2[ToViewKey]
		let contentType = animation2[ScreenKey]
		let animated = animation2[AnimatedKey]
		
		if (fromView as? UIView) != nil {
			result[FromViewKey] = fromView!
		}
		if (toView as? UIView) != nil {
			result[ToViewKey] = toView!
		}
		if (contentType as? ContentType.RawValue) != nil {
			result[ScreenKey] = contentType!
		}
		if (animated as? Bool) != nil {
			result[AnimatedKey] = animated!
		}
		return result
	}
	
	fileprivate func addAnimation(_ animation: AnimationDict) {
		if animationQueue.count > 0 {
			let animationFromQueue = animationQueue.first!
			animationQueue.removeAll()
			animationQueue.append(mergedAnimation(animationFromQueue, animation2: animation))
		} else {
			animationQueue.insert(animation, at: 0)
		}
		
		delay(0.0) {
			self.startNextAnimationIfNeeded()
		}
	}
	
	fileprivate func cancellAllAnimations() {
		animationQueue.removeAll()
		currentAnimation = nil
	}
	
	fileprivate func performAnimation(_ animation: AnimationDict) {
		let fromView = animation[FromViewKey]
		let toView = animation[ToViewKey]
		let contentType = animation[ScreenKey]
		let animated = animation[AnimatedKey]
		
		if (animated as? Bool) != true {
			for queueAnimation in animationQueue.reversed() {
				let fromView = queueAnimation[FromViewKey]
				let toView = queueAnimation[ToViewKey]
				let contentType = queueAnimation[ScreenKey]
				performTransitionFromView(fromView as? UIView, toView: toView! as! UIView, animated: false, contentType: ContentType(rawValue: contentType! as! Int)!)
			}
		}
		performTransitionFromView(fromView as? UIView, toView: toView! as! UIView, animated: animated! as! Bool, contentType: ContentType(rawValue: contentType! as! Int)!)
	}
	
	fileprivate func isContentViewAvailable(_ checkingView: UIView?) -> Bool {
		
		var result = false
		if checkingView == nil {
			return result
		}
	
		let theView = checkingView!
		while let theViewUnw = theView.superview {
			if theViewUnw == self.view { break }
			if theViewUnw == self.contentView {
				result = true
				break
			}
		}
		
		return result
	}
	
	fileprivate func animationOptions() -> UIViewAnimationOptions {
		return [.transitionCrossDissolve, .layoutSubviews]
	}
	
	fileprivate func performTransitionFromView(_ fromView: UIView?, toView: UIView, animated: Bool, contentType: ContentType) {
		
		func finish() {
			currentAnimation = nil
			startNextAnimationIfNeeded()
		}
		
		if contentType != .Content {
			addView(toView)
		}
		
		let theFromView = fromView
		let theFromViewInConentView = isContentViewAvailable(theFromView)
		let fromViewIsContentView = (theFromView == self.contentView)
		
		let theToView = toView
		let theToViewInContentView = isContentViewAvailable(theToView)
		let toViewIsContentView = (theToView == self.contentView)
		
		if fromViewIsContentView && toViewIsContentView {
			finish()
			return
		}
		
		let contentViewAlpha = (theToViewInContentView || toViewIsContentView) ? 1.0 : 0.0
		let removesFromView = !fromViewIsContentView
		let animatesToView = (!theFromViewInConentView || !fromViewIsContentView)
		let animatesFromView = !fromViewIsContentView
		
		func animations() {
			if animatesToView {
				toView.alpha = 1.0
			}
			if animatesFromView {
				if let fromView = fromView {
					fromView.alpha = 0.0
				}
			}
			self.contentView.alpha = CGFloat(contentViewAlpha)
		}
		
		func completion() {
			if removesFromView {
				if let fromView = fromView {
					fromView.removeFromSuperview()
				}
			}
			finish()
		}
		
		if animated {
			theToView.alpha = 0.0
			UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOptions(), animations: {
				animations()
				}, completion: { finished in
					if finished {
						completion()
					}
			})
		} else {
			animations()
			completion()
		}
	}
	
	fileprivate func startNextAnimationIfNeeded() {
		guard self.currentAnimation == nil else { return }
		guard let lastAnimation = animationQueue.last else { return }
		
		self.currentAnimation = lastAnimation
		self.animationQueue.removeLast()
		self.performAnimation(lastAnimation)
	}
}
