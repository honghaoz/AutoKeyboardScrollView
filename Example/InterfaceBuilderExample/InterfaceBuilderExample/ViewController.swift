//
//  ViewController.swift
//  InterfaceBuilderExample
//
//  Created by Honghao Zhang on 2015-09-10.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit
import AutoKeyboardScrollView

class ViewController: UIViewController {

	@IBOutlet weak var wrapperView: UIView!
	var scrollView = AutoKeyboardScrollView()
	var views = [String: UIView]()
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupViews()
		setupConstraints()
	}
	
	func setupViews() {
		scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
		view.addSubview(scrollView)
		
		// Remove from super to remove all self constraints
		wrapperView.removeFromSuperview()
		
		wrapperView.setTranslatesAutoresizingMaskIntoConstraints(false)
		// Be sure to add subviews on contentView
		scrollView.contentView.addSubview(wrapperView)
		
		scrollView.backgroundColor = wrapperView.backgroundColor
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
