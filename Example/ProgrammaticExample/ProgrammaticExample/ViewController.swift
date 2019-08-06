//
//  ViewController.swift
//  ProgrammaticExample
//
//  Created by Honghao Zhang on 2015-09-10.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit
import AutoKeyboardScrollView

class ViewController: UIViewController {
	
	let scrollView = AutoKeyboardScrollView()
	var views = [String: UIView]()

    override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupViews()
		setupConstraints()
	}
	
	private func setupViews() {
		views["scrollView"] = scrollView
		
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.backgroundColor = UIColor(red:0.31, green:0.66, blue:0.42, alpha:1)
        scrollView.isUserInteractionEnabled = true
		scrollView.bounces = true
        scrollView.isScrollEnabled = true
		
		scrollView.textFieldMargin = 18
		
		view.addSubview(scrollView)
		
		// NOTE: Add subview on contentView!
		for i in 0 ..< 8 {
            scrollView.contentView.addSubview(newTextField(id: i))
		}
		
		// A text field on a subview
		let dummyView = UIView()
		dummyView.backgroundColor = UIColor(white: 1.0, alpha: 0.4)
		dummyView.translatesAutoresizingMaskIntoConstraints = false
		views["dummyView"] = dummyView
		
        let textField8 = newTextField(id: 8)
		textField8.placeholder = "Text filed on a deeper subview"
		dummyView.addSubview(textField8)
		scrollView.contentView.addSubview(dummyView)
        scrollView.setTextMargin(100, forTextField: textField8)
	}
	
	private func setupConstraints() {
		var constraints = [NSLayoutConstraint]()
		
		// Constraints for scorllView
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[scrollView]|", options: [], metrics: nil, views: views)
		
		// Center width constraints for text fields
		for i in 0 ..< 8 {
            addWidthCenterXConstraintsForView(view: views["textField\(i)"]!, width: 200)
		}
		
		
		// Constraints for dummy subview and textfield
        addWidthCenterXConstraintsForView(view: views["dummyView"]!, width: 280)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[textField8]-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[textField8]-|", options: [], metrics: nil, views: views)
		
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(100)-[textField0(30)]-(20)-[textField1(30)]-(20)-[textField2(30)]-(20)-[textField3(30)]-(20)-[textField4(30)]-(20)-[textField5(30)]-(20)-[textField6(30)]-(20)-[textField7(30)]-(20)-[dummyView(50)]-(150)-|", options: [], metrics: nil, views: views)
		
        NSLayoutConstraint.activate(constraints)
	}
	
	
	// MARK: - Helpers
	private func newTextField(id: Int) -> UITextField {
		let textField = UITextField()
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.placeholder = "Type here..."
        textField.textAlignment = NSTextAlignment.center
		textField.backgroundColor = .white
		
		views["textField\(id)"] = textField
		
		return textField
	}
	
	private func addWidthCenterXConstraintsForView(view: UIView, width: CGFloat) {
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0, constant: width))
		view.superview!.addConstraint(NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: view.superview!, attribute: .centerX, multiplier: 1, constant: 0))
	}
}
