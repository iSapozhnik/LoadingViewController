//
//  ViewController.swift
//  LoadingViewController
//
//  Created by Sapozhnik Ivan on 06/29/2016.
//  Copyright (c) 2016 Sapozhnik Ivan. All rights reserved.
//

import UIKit
import LoadingViewController

class ViewController: LoadingViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
        // Do any additional setup after loading the view, typically from a nib.

		delay(1.0) { [weak self] in
			self?.setVisibleScreen(.Loading)
			self?.delay(3, closure: { [weak self] in
				let userInfo = [NSLocalizedDescriptionKey:NSLocalizedString("Operation was unsuccessful.", comment: ""), NSLocalizedFailureReasonErrorKey:NSLocalizedString("The operation timed out.", comment:""), NSLocalizedRecoverySuggestionErrorKey:NSLocalizedString("Have you tried turning it off and on again?", comment: "")]
				let error = NSError(domain: "some doman", code: 1000, userInfo: userInfo)
				self?.lastError = error
				
				self?.errorIcon = UIImage(named: "doc_fail")
				self?.setVisibleScreen(.Failure)
				self?.delay(2, closure: {
					self?.setVisibleScreen(.Loading)
					self?.delay(2, closure: { [weak self] in
						self?.setVisibleScreen(.Content)
						})
				})
			})
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	override func loadingViewStyle() -> LoadingViewStyle {
		return .Stroke
	}
}

