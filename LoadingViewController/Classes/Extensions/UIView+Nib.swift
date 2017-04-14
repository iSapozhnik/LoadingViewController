//
//  UIView+Nib.swift
//  Pods
//
//  Created by Sapozhnik Ivan on 30.06.16.
//
//

import UIKit

protocol UIViewLoading {}
extension UIView : UIViewLoading {}

extension UIViewLoading where Self : UIView {
	
	static func loadFromNib() -> Self {
		let nibName = "\(self)".characters.split{$0 == "."}.map(String.init).last!
		let bundle = Bundle(for: self)
		let nib = UINib(nibName: nibName, bundle: bundle)
		return nib.instantiate(withOwner: self, options: nil).first as! Self
	}
}
