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

    override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
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
        scrollView.isUserInteractionEnabled = true
		scrollView.bounces = true
        scrollView.isScrollEnabled = true
	}
	
	func setupConstraints() {
		views["scrollView"] = scrollView
		views["wrapperView"] = wrapperView
		
		var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", options: [], metrics: nil, views: views)
        constraints +=  NSLayoutConstraint.constraints(withVisualFormat: "V:|[scrollView]|", options: [], metrics: nil, views: views)
		
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[wrapperView]|", options: [], metrics: nil, views: views)
        constraints +=  NSLayoutConstraint.constraints(withVisualFormat: "V:|[wrapperView]|", options: [], metrics: nil, views: views)
		
        NSLayoutConstraint.activate(constraints)
	}
}
