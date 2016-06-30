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
				self?.errorTitle = "Lorem ipsum dolor sit amet, et nisl rebum viderer nam."
				self?.errorIcon = UIImage(named: "doc_fail")
				self?.errorMessage = "Ne laudem expetendis intellegam nec. Vel eu veritus omnesque, ei dolorem oporteat eos, admodum praesent te vix. Vel albucius oportere euripidis ne. Eum in timeam persius, no labore persequeris per, ea vix adhuc postulant."
				self?.setVisibleScreen(.Failure)
				self?.delay(1, closure: {
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
		return .Multicolor
	}
}

