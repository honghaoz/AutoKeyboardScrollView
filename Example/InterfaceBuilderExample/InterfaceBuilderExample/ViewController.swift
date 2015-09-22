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
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(scrollView)
		
		// Remove from super to remove all self constraints
		wrapperView.removeFromSuperview()
		
		wrapperView.translatesAutoresizingMaskIntoConstraints = false
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
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[scrollView]|", options: [], metrics: nil, views: views)
		constraints +=  NSLayoutConstraint.constraintsWithVisualFormat("V:|[scrollView]|", options: [], metrics: nil, views: views)
		
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[wrapperView]|", options: [], metrics: nil, views: views)
		constraints +=  NSLayoutConstraint.constraintsWithVisualFormat("V:|[wrapperView]|", options: [], metrics: nil, views: views)
		
		NSLayoutConstraint.activateConstraints(constraints)
	}
}
