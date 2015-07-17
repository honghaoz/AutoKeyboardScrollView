//
//  ViewController.swift
//  AutoKeyboardScrollView_Interface_Builder_Example
//
//  Created by Honghao Zhang on 2015-07-14.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import AutoKeyboardScrollView

class ViewController: UIViewController {

	@IBOutlet weak var wrapperView: UIView!
	var scrollView: AutoKeyboardScrollView!
	var views = [String: UIView]()
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return UIStatusBarStyle.LightContent
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupViews()
		setupConstraints()
	}
	
	func setupViews() {
		scrollView = AutoKeyboardScrollView()
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
