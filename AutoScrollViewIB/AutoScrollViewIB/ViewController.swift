//
//  ViewController.swift
//  AutoScrollViewIB
//
//  Created by Honghao Zhang on 2015-07-08.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet weak var wrapperView: UIView!
	var scrollView: ZHAutoScrollView!
	var views = [String: UIView]()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupViews()
		setupConstraints()
	}
	
	func setupViews() {
		scrollView = ZHAutoScrollView()
		scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
		self.view.addSubview(scrollView)
		
		// Remove from super to remove all self constraints
		wrapperView.removeFromSuperview()
		
		wrapperView.setTranslatesAutoresizingMaskIntoConstraints(false)
		// Be sure to add subviews on contentView
		scrollView.contentView.addSubview(wrapperView)
		
		scrollView.userInteractionEnabled = true
		scrollView.bounces = true
		scrollView.scrollEnabled = true
	}
	
	func setupConstraints() {
		views["scrollView"] = scrollView
		views["wrapperView"] = wrapperView
		
		var constraints = [NSLayoutConstraint]()
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[scrollView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views) as! [NSLayoutConstraint]
		constraints +=  NSLayoutConstraint.constraintsWithVisualFormat("V:|[scrollView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views) as! [NSLayoutConstraint]
		
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[wrapperView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views) as! [NSLayoutConstraint]
		constraints +=  NSLayoutConstraint.constraintsWithVisualFormat("V:|[wrapperView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views) as! [NSLayoutConstraint]
		
		NSLayoutConstraint.activateConstraints(constraints)
	}
}

