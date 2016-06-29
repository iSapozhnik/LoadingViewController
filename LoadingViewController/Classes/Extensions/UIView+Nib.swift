//
//  UIView+Nib.swift
//  Pods
//
//  Created by Sapozhnik Ivan on 29.06.16.
//
//

import Foundation

// http://stackoverflow.com/a/26326006/1320184

public extension UIView {
	
	public class func fromNib(nibNameOrNil: String? = nil) -> Self {
		return fromNib(nibNameOrNil, type: self)
	}
	
	public class func fromNib<T : UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T {
		let v: T? = fromNib(nibNameOrNil, type: T.self)
		return v!
	}
	
	public class func fromNib<T : UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T? {
		var view: T?
		let name: String
		if let nibName = nibNameOrNil {
			name = nibName
		} else {
			// Most nibs are demangled by practice, if not, just declare string explicitly
			name = nibName
		}
		
		let allBundles = NSBundle.allBundles()[1]
		
		let mainBundle = NSBundle.mainBundle()
//		let bundlePath = NSBundle.mainBundle().pathForResource("LoadingViewController", ofType: "bundle")
//		let oneMoreBundle = NSBundle(path: bundlePath!)
		
		let classBundle = NSBundle(forClass: object_getClass(self))

		let nibViews = mainBundle.loadNibNamed(name, owner: nil, options: nil)
		for v in nibViews {
			if let tog = v as? T {
				view = tog
			}
		}
		return view
	}
	
	public class var nibName: String {
		let name = "\(self)".componentsSeparatedByString(".").first ?? ""
		return name
	}
	public class var nib: UINib? {
		if let _ = NSBundle.mainBundle().pathForResource(nibName, ofType: "nib") {
			return UINib(nibName: nibName, bundle: nil)
		} else {
			return nil
		}
	}
}