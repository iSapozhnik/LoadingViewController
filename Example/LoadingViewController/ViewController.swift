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
				self?.NoDataMessage = "You don't have any search results. Please, refine your search criteria and try again."
				self?.customErrorTitle = "Hello World!"
				self?.errorActionTitle = "Oops!"
				self?.setVisibleScreen(.Failure, actionHandler: {
					
				})
			})
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	override func loadingViewStyle() -> LoadingViewStyle {
		return .indicator
	}
}

