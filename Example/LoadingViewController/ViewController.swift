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
		
		delay(3.0) { [weak self] in
			self?.setVisibleScreen(.Loading)
			self?.delay(3, closure: { [weak self] in
				self?.setVisibleScreen(.Failure)
			})
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

