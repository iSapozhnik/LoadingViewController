//
//  SimpleNoDataView.swift
//  Pods
//
//  Created by Sapozhnik Ivan on 13.07.16.
//
//

import UIKit

class SimpleNoDataView: NoDataView {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet var messageLabel: UILabel!
	
	override func didSetMessage() {
		messageLabel?.text = message ?? ""
		layoutIfNeeded()
	}
	
	override func didSetImage() {
		guard let newImage = image else { return }
		imageView?.image = newImage
	}

}
