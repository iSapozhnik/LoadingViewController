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
	public func delay(delay:Double, closure:()->()) {
		dispatch_after(
			dispatch_time(
				DISPATCH_TIME_NOW,
				Int64(delay * Double(NSEC_PER_SEC))
			),
			dispatch_get_main_queue(), closure)
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
let animationDuration: NSTimeInterval = 0.3;


typealias AnimationDict = Dictionary<String, AnyObject>
public typealias ActionHandler = () -> ()

public class LoadingViewController: UIViewController {

	@IBOutlet public var contentView: UIView!
	
	public var lastError: NSError?
	
	var visibleContentType: ContentType = .Undefined
	var activeView: UIView?
	
	var animationQueue = Array<AnimationDict>()
	var currentAnimation: AnimationDict?
	
	public var errorTitle: String {
		get {
			return lastError?.localizedDescription ?? NSLocalizedString("Oops, something went wrong", comment: "")
		}
	}
	public var errorMessage: String {
		get {
			return lastError?.localizedFailureReason ?? NSLocalizedString("Please try again later", comment: "")
		}
	}
	public var errorIcon: UIImage?
	public var errorAction: String?
	
	var noDataAction: String?
	public var noDataMessage: String = NSLocalizedString("No data availabel", comment: "")

	var contentViewAllwaysAvailabel: Bool = false
	
	//MARK:- Default views
	
	func defaultNoDataView() -> UIView {
		//TODO: create default view for No Data
		return UIView()
	}
	
	func defaultErrorView() -> UIView {
		let view = ErrorView.viewWithStyle(errorViewStyle(), actionHandler: nil)
		view.title = errorTitle
		view.message = errorMessage
		view.image = errorIcon
		return view
	}
	
	func defaultLoadingView() -> UIView {
		let view = LoadingView.viewWithStyle(loadingViewStyle())
		
		//TODO: add title, background image, etc.
		view.title = "Loading"
		return view
	}
	
	public func loadingViewStyle() -> LoadingViewStyle {
		return .Indicator
	}
	
	public func errorViewStyle() -> ErrorViewStyle {
		return .Simple
	}

	public func showsErrorView() -> Bool {
		return true
	}
	
	public func showsNoDataView() -> Bool {
		return true
	}
	
	public func showsLoadingView() -> Bool {
		return true
	}
	
	func addView(viewToAdd: UIView) {
		view.addSubview(viewToAdd)
		viewToAdd.translatesAutoresizingMaskIntoConstraints = false
		let bindings = ["view": viewToAdd]
		view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[view]|", options: [.AlignAllLeading, .AlignAllTrailing], metrics: nil, views: bindings))
		view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: [.AlignAllTop, .AlignAllBottom], metrics: nil, views: bindings))
		view.layoutIfNeeded()
	}
	
	func viewForScreen(contentType: ContentType) -> UIView {
		switch contentType {
		case .Content:
			return contentView
		case .Failure:
			return defaultErrorView()
		case .Loading:
			return defaultLoadingView()
		case .NoData:
			return defaultNoDataView()
		case .Undefined, .Empty:
			let result = UIView()
			result.backgroundColor = .redColor()
			return result
		}
	}
	
	// TODO: add ActionHandler support to handle 'Retry' tap on ErrorViews
	public func setVisibleScreen(contentType: ContentType, animated: Bool = true, actionHandler:ActionHandler? = nil) {
		if visibleContentType != contentType {
			visibleContentType = contentType
			setActiveView(viewForScreen(visibleContentType), animated: animated)
		}
	}

	func setActiveView(viewToSet: UIView, animated: Bool) {
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
	
	private func animationFormView(fromView: UIView?, toView: UIView, contentType: ContentType, animated: Bool) -> AnimationDict {
		var data = AnimationDict()
		data[FromViewKey] = fromView
		data[ToViewKey] = toView
		data[AnimatedKey] = animated
		data[ScreenKey] = contentType.rawValue
		return data
	}
	
	private func mergedAnimation(animation1: AnimationDict, animation2: AnimationDict) -> AnimationDict {
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
	
	private func addAnimation(animation: AnimationDict) {
		if animationQueue.count > 0 {
			let animationFromQueue = animationQueue.first!
			animationQueue.removeAll()
			animationQueue.append(mergedAnimation(animationFromQueue, animation2: animation))
		} else {
			animationQueue.insert(animation, atIndex: 0)
		}
		
		delay(0.0) {
			self.startNextAnimationIfNeeded()
		}
	}
	
	private func cancellAllAnimations() {
		animationQueue.removeAll()
		currentAnimation = nil
	}
	
	private func performAnimation(animation: AnimationDict) {
		let fromView = animation[FromViewKey]
		let toView = animation[ToViewKey]
		let contentType = animation[ScreenKey]
		let animated = animation[AnimatedKey]
		
		if (animated as? Bool) != true {
			for queueAnimation in animationQueue.reverse() {
				let fromView = queueAnimation[FromViewKey]
				let toView = queueAnimation[ToViewKey]
				let contentType = queueAnimation[ScreenKey]
				performTransitionFromView(fromView as? UIView, toView: toView! as! UIView, animated: false, contentType: ContentType(rawValue: contentType! as! Int)!)
			}
		}
		performTransitionFromView(fromView as? UIView, toView: toView! as! UIView, animated: animated! as! Bool, contentType: ContentType(rawValue: contentType! as! Int)!)
	}
	
	private func isContentViewAvailable(checkingView: UIView) -> Bool {
		
		var result = false
	
		let theView = checkingView
		while let theViewUnw = theView.superview {
			if theViewUnw == self.view { break }
			if theViewUnw == self.contentView {
				result = true
				break
			}
		}
		
		return result
	}
	
	private func animationOptions() -> UIViewAnimationOptions {
		return [.TransitionCrossDissolve, .LayoutSubviews, .CurveEaseInOut]
	}
	
	private func performTransitionFromView(fromView: UIView?, toView: UIView, animated: Bool, contentType: ContentType) {
		
		func finish() {
			currentAnimation = nil
			startNextAnimationIfNeeded()
		}
		
		if contentType != .Content {
			addView(toView)
		}
		
		let theFromView = fromView
		let fromViewIsContentView = (theFromView == self.contentView)
		
		let theToView = toView
		let toViewIsContentView = (theToView == self.contentView)
		
		if fromViewIsContentView && toViewIsContentView {
			finish()
			return
		}
		
		let contentViewAlpha = (toViewIsContentView || fromViewIsContentView) ? 1.0 : 0.0
		let removesFromView = !fromViewIsContentView
		let animatesToView = (!fromViewIsContentView || !toViewIsContentView)
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
			UIView.animateWithDuration(animationDuration, delay: 0.0, options: animationOptions(), animations: {
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
	
	private func startNextAnimationIfNeeded() {
		guard self.currentAnimation == nil else { return }
		guard let lastAnimation = animationQueue.last else { return }
		
		self.currentAnimation = lastAnimation
		self.animationQueue.removeLast()
		self.performAnimation(lastAnimation)
	}
}
