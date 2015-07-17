//
//  ViewController.swift
//  AutoKeyboardScrollView
//
//  Created by Honghao Zhang on 07/14/2015.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit
import AutoKeyboardScrollView

class ViewController: UIViewController {

	var scrollView: AutoKeyboardScrollView!
	var views = [String: UIView]()
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return UIStatusBarStyle.LightContent
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = UIColor.whiteColor()
		
		setupViews()
		setupConstraints()
    }

	func setupViews() {
		scrollView = AutoKeyboardScrollView()
		views["scrollView"] = scrollView
		
		scrollView.backgroundColor = UIColor(red:0.31, green:0.66, blue:0.42, alpha:1)
		scrollView.userInteractionEnabled = true
		scrollView.bounces = true
		scrollView.scrollEnabled = true
		
		scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
		self.view.addSubview(scrollView)
		
		// NOTE: Add subview on contentView!
		for i in 0 ..< 8 {
			scrollView.contentView.addSubview(newTextField(i))
		}
		
		// A text field on a subview
		let dummyView: UIView = UIView()
		dummyView.backgroundColor = UIColor(white: 1.0, alpha: 0.4)
		dummyView.setTranslatesAutoresizingMaskIntoConstraints(false)
		views["dummyView"] = dummyView
		
		let textField8 = newTextField(8)
		textField8.placeholder = "I'm on another view"
		dummyView.addSubview(textField8)
		scrollView.contentView.addSubview(dummyView)
	}
	
	func setupConstraints() {
		var constraints = [NSLayoutConstraint]()
		
		// Constraints for scorllView
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[scrollView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views) as! [NSLayoutConstraint]
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[scrollView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views) as! [NSLayoutConstraint]
		
		// Center width constraints for text fields
		for i in 0 ..< 8 {
			addWidthCenterXConstraintsForView(views["textField\(i)"]!, width: 200)
		}
		
		
		// Constraints for dummy subview and textfield
		addWidthCenterXConstraintsForView(views["dummyView"]!, width: 280)
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[textField8]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: views) as! [NSLayoutConstraint]
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-[textField8]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: views) as! [NSLayoutConstraint]
		
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-(50)-[textField0(30)]-(20)-[textField1(30)]-(20)-[textField2(30)]-(20)-[textField3(30)]-(20)-[textField4(30)]-(20)-[textField5(30)]-(20)-[textField6(30)]-(20)-[textField7(30)]-(20)-[dummyView(50)]-(150)-|", options: NSLayoutFormatOptions(0), metrics: nil, views: views) as! [NSLayoutConstraint]
		
		NSLayoutConstraint.activateConstraints(constraints)
	}
	
	
	// MARK: - Helpers
	func newTextField(id: Int) -> UITextField {
		let textField = UITextField()
		textField.setTranslatesAutoresizingMaskIntoConstraints(false)
		textField.placeholder = "Type here..."
		textField.textAlignment = NSTextAlignment.Center
		textField.backgroundColor = UIColor.whiteColor()
		
		views["textField\(id)"] = textField
		
		return textField
	}
	
	func addWidthCenterXConstraintsForView(view: UIView, width: CGFloat) {
		view.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Width, multiplier: 0, constant: width))
		view.superview!.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view.superview!, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
	}
}
