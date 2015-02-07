//
//  ViewController.swift
//  ZHAutoScrollViewDemo
//
//  Created by Honghao Zhang on 2/1/15.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var scrollView: ZHAutoScrollView!
    
    var viewDictionary = [String: UIView]()
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    func setupViews() {
        scrollView = ZHAutoScrollView()
        scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(scrollView)
        scrollView.backgroundColor = UIColor.brownColor()
        viewDictionary["scrollView"] = scrollView
        var hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[scrollView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDictionary)
        var vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[scrollView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDictionary)
        self.view.addConstraints(hConstraints)
        self.view.addConstraints(vConstraints)
        
        // Add textFields
        let textField = UITextField()
        textField.setTranslatesAutoresizingMaskIntoConstraints(false)
        textField.placeholder = "Type here..."
        textField.textAlignment = NSTextAlignment.Center
        textField.backgroundColor = UIColor.whiteColor()
        scrollView.contentView.addSubview(textField)
        viewDictionary["textField"] = textField
        addWidthCenterXConstraintsForView(textField, width: 200)
        
        let textField2 = UITextField()
        textField2.setTranslatesAutoresizingMaskIntoConstraints(false)
        textField2.placeholder = "Type here..."
        textField2.textAlignment = NSTextAlignment.Center
        textField2.backgroundColor = UIColor.whiteColor()
        scrollView.contentView.addSubview(textField2)
        viewDictionary["textField2"] = textField2
        addWidthCenterXConstraintsForView(textField2, width: 200)
        
        let textField3 = UITextField()
        textField3.setTranslatesAutoresizingMaskIntoConstraints(false)
        textField3.placeholder = "Type here..."
        textField3.textAlignment = NSTextAlignment.Center
        textField3.backgroundColor = UIColor.whiteColor()
        scrollView.contentView.addSubview(textField3)
        viewDictionary["textField3"] = textField3
        addWidthCenterXConstraintsForView(textField3, width: 200)
        
        let textField4 = UITextField()
        textField4.setTranslatesAutoresizingMaskIntoConstraints(false)
        textField4.placeholder = "Type here..."
        textField4.textAlignment = NSTextAlignment.Center
        textField4.backgroundColor = UIColor.whiteColor()
        scrollView.contentView.addSubview(textField4)
        viewDictionary["textField4"] = textField4
        addWidthCenterXConstraintsForView(textField4, width: 200)
        
        let textField5 = UITextField()
        textField5.setTranslatesAutoresizingMaskIntoConstraints(false)
        textField5.placeholder = "Type here..."
        textField5.textAlignment = NSTextAlignment.Center
        textField5.backgroundColor = UIColor.whiteColor()
        scrollView.contentView.addSubview(textField5)
        viewDictionary["textField5"] = textField5
        addWidthCenterXConstraintsForView(textField5, width: 200)
        
        let textField6 = UITextField()
        textField6.setTranslatesAutoresizingMaskIntoConstraints(false)
        textField6.placeholder = "Type here..."
        textField6.textAlignment = NSTextAlignment.Center
        textField6.backgroundColor = UIColor.whiteColor()
        scrollView.contentView.addSubview(textField6)
        viewDictionary["textField6"] = textField6
        addWidthCenterXConstraintsForView(textField6, width: 200)
        
        // Text field on a containerView
        let containerView: UIView = UIView()
        containerView.backgroundColor = UIColor(white: 1.0, alpha: 0.4)
        containerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let textField7 = UITextField()
        textField7.setTranslatesAutoresizingMaskIntoConstraints(false)
        textField7.placeholder = "Type here..."
        textField7.textAlignment = NSTextAlignment.Center
        textField7.backgroundColor = UIColor.whiteColor()
        containerView.addSubview(textField7)
        viewDictionary["textField7"] = textField7
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[textField7]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDictionary))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[textField7]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDictionary))
        
        scrollView.contentView.addSubview(containerView)
        viewDictionary["containerView"] = containerView
        addWidthCenterXConstraintsForView(containerView, width: 280)
        
        vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(50)-[textField(30)]-(20)-[textField2(30)]-(20)-[textField3(30)]-(20)-[textField4(30)]-(20)-[textField5(30)]-(20)-[textField6(30)]-(20)-[containerView(50)]-(150)-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDictionary)
        scrollView.contentView.addConstraints(vConstraints)
        
        scrollView.userInteractionEnabled = true
        scrollView.bounces = true
        scrollView.scrollEnabled = true
    }
    
    func addWidthCenterXConstraintsForView(view: UIView, width: CGFloat) {
        view.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Width, multiplier: 0, constant: width))
        view.superview!.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view.superview!, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
    }
}

