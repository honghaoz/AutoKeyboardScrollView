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
        var vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(40)-[scrollView]-(100)-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDictionary)
        self.view.addConstraints(hConstraints)
        self.view.addConstraints(vConstraints)
        
        let textField = UITextField()
        textField.setTranslatesAutoresizingMaskIntoConstraints(false)
        textField.placeholder = "Type here..."
        textField.textAlignment = NSTextAlignment.Center
        
        scrollView.contentView.addSubview(textField)
        textField.addConstraint(NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: textField, attribute: NSLayoutAttribute.Width, multiplier: 0, constant: 200))
        textField.addConstraint(NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: textField, attribute: NSLayoutAttribute.Height, multiplier: 0, constant: 40))
        
        scrollView.contentView.addConstraint(NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: scrollView.contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0))
        scrollView.contentView.addConstraint(NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: scrollView.contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0))
        
        scrollView.userInteractionEnabled = true
        scrollView.bounces = true
        scrollView.scrollEnabled = true
        scrollView.contentInset = UIEdgeInsetsMake(50, 0, 50, 0)
    }
}

