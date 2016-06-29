//
//  SimpleErrorView.swift
//  Pods
//
//  Created by Sapozhnik Ivan on 29.06.16.
//
//

import UIKit

class SimpleErrorView: ErrorView {

	var view: UIView!
	
	private func xibSetup() {
		view = loadViewFromNib()
		view.frame = bounds
		addSubview(view)
	}
	
	convenience init() {
		self.init(frame: CGRectZero)
		xibSetup()
	}
	
	private func loadViewFromNib() -> UIView {
		
		let bundle = NSBundle(forClass: self.dynamicType)
		let name = "\(self.dynamicType)".componentsSeparatedByString(".").last ?? ""
		let nib = UINib(nibName: name, bundle: bundle)
		let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
		
		return view
	}

}
