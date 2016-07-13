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
	
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet var messageLabel: UILabel!
	
	override func didSetTitle() {
		titleLabel?.text = title
		layoutIfNeeded()
	}
	
	override func didSetMessage() {
		messageLabel?.text = message ?? ""
		layoutIfNeeded()
	}
	
	override func didSetImage() {
		guard let newImage = image else { return }
		imageView?.image = newImage
	}
	
	@IBAction func action(sender: AnyObject) {
		action?()
	}
}
