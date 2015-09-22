//
//  ProgrammaticExampleTests.swift
//  ProgrammaticExampleTests
//
//  Created by Honghao Zhang on 2015-09-10.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit
import XCTest
import AutoKeyboardScrollView

class ProgrammaticExampleTests: XCTestCase {
	
	let scrollView = AutoKeyboardScrollView()
	
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddingToSubview() {
		let view = UIView()
		
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.backgroundColor = UIColor(red:0.31, green:0.66, blue:0.42, alpha:1)
		scrollView.userInteractionEnabled = true
		scrollView.bounces = true
		scrollView.scrollEnabled = true
		
		scrollView.textFieldMargin = 18
		
		view.addSubview(scrollView)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
