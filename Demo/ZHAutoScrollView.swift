//
//  ZHAutoScrollView.swift
//
//  Created by Honghao Zhang on 2/1/15.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit

class ZHAutoScrollView: UIScrollView {
    
    // ZHContentScroll is a private class for ZHAutoScrollView
    private class ZHContentScrollView: UIScrollView {
        var textFields = [UITextField]()
        
        override func addSubview(view: UIView) {
            super.addSubview(view)
            if let textField: UITextField = (view as? UITextField) {
                textFields.append(textField)
                setupActionsForTextField(textField)
            }
        }
        
        func setupActionsForTextField(textField: UITextField) {
            if textField.actionsForTarget(self.superview!, forControlEvent: UIControlEvents.EditingDidBegin) == nil {
                textField.addTarget(self.superview!, action: "_textFiledEditingDidBegin:", forControlEvents: UIControlEvents.EditingDidBegin)
            }
            
            if textField.actionsForTarget(self.superview!, forControlEvent: UIControlEvents.EditingChanged) == nil {
                textField.addTarget(self.superview!, action: "_textFiledEditingChanged:", forControlEvents: UIControlEvents.EditingChanged)
            }
            
            if textField.actionsForTarget(self.superview!, forControlEvent: UIControlEvents.EditingDidEnd) == nil {
                textField.addTarget(self.superview!, action: "_textFiledEditingDidEnd:", forControlEvents: UIControlEvents.EditingDidEnd)
            }
            
//            if textField.actionsForTarget(self.superview!, forControlEvent: UIControlEvents.EditingDidEndOnExit) == nil {
//                textField.addTarget(self.superview!, action: "_textFiledEditingDidEndOnExit:", forControlEvents: UIControlEvents.EditingDidEndOnExit)
//            }
        }
    }
    
    // All subViews should be added on contentView
    var contentView: UIView!

    var originalContentInset: UIEdgeInsets!
    var originalContentOffset: CGPoint!
    var keyboardFrame: CGRect!
    var keyboardAnimationDuration: NSTimeInterval!
    
    var textFields: [UITextField] {
        get {
            return (contentView as ZHContentScrollView).textFields
        }
    }
    var activeTextField: UITextField?
    
    override convenience init() {
        self.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        setupContentView()
        setupGestures()
        registerNotifications()
    }
     
    private func setupContentView() {
        contentView = ZHContentScrollView()
        contentView.setTranslatesAutoresizingMaskIntoConstraints(false)
        (contentView as UIScrollView).delaysContentTouches = false
        self.addSubview(contentView)
        
        let top = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0)
        let left = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0.0)
        let bottom = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0)
        let right = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0.0)
        
        // Width and height constraints with a lower priority
        let width = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0.0)
        // Set its priority to be a very low value, to avoid conflicts
        width.priority = 10
        let height = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: self, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0.0)
        height.priority = 10
        self.addConstraints([top, left, bottom, right, width, height])
    }
}

// MARK: TapGesture
extension ZHAutoScrollView {
    private func setupGestures() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "selfIsTapped:"))
    }
    
    func selfIsTapped(gesture: UITapGestureRecognizer) {
        activeTextField?.resignFirstResponder()
    }
}

// MARK: TextFields Actions
extension ZHAutoScrollView {
    func _textFiledEditingDidBegin(sender: AnyObject) {
        activeTextField = sender as? UITextField
        if self.keyboardFrame != nil { makeActiveTextFieldVisible(self.keyboardFrame) }
    }
    
    func _textFiledEditingChanged(sender: AnyObject) {
        makeActiveTextFieldVisible(self.keyboardFrame)
    }
    
    func _textFiledEditingDidEnd(sender: AnyObject) {
        //
    }
    
//    func _textFiledEditingDidEndOnExit(sender: AnyObject) {
//        println("_textFiledEditingDidEndOnExit")
//    }
}

// MARK: Keyboard Notification
extension ZHAutoScrollView {
    private func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "keyboardWillChange:",
            name: UIKeyboardWillChangeFrameNotification,
            object: nil)
    }
    
    func keyboardWillChange(notification: NSNotification) {
        if isKeyboardWillShow(notification) {
            // Preserved original contentInset and contentOffset
            self.originalContentInset = self.contentInset
            self.originalContentOffset = self.contentOffset
            
            let endFrame = keyboardEndFrame(notification)
            // Init keyboardAnimationDuration and keyboardFrame
            self.keyboardFrame = endFrame
            self.keyboardAnimationDuration = keyboardDismissingDuration(notification)
            
            makeActiveTextFieldVisible(endFrame)
        } else if isKeyboardWillHide(notification) {
            // Animated to restore to original state
            UIView.animateWithDuration(keyboardDismissingDuration(notification), animations: { () -> Void in
                self.contentInset = self.originalContentInset
                self.contentOffset = self.originalContentOffset
            }, completion: { (completed) -> Void in
                self.keyboardFrame = nil
            })
        } else {
            // This will be called when keyboard size is changed when it's still displaying
            let endFrame = keyboardEndFrame(notification)
            self.keyboardFrame = endFrame
            makeActiveTextFieldVisible(endFrame)
        }
    }
    
    /**
    Make sure active textField is visible
    Note: scrollView's contentInset will be changed
    
    :param: keyboardRect Current keyboard frame
    */
    func makeActiveTextFieldVisible(var keyboardRect: CGRect) {
        if activeTextField == nil { return }
        // flipLandscapeFrameForIOS7 only changes CGRect for landscape on iOS7
        keyboardRect = flipLandscapeFrameForIOS7(keyboardRect)
//        var keyboardHeight: CGFloat = keyboardRect.size.height
        
//        // VisibleWindowFrame
//        var visibleWindowFrame = UIScreen.mainScreen().bounds
//        visibleWindowFrame = flipLandscapeFrameForIOS7(visibleWindowFrame)
//        visibleWindowFrame.size.height -= keyboardHeight
        
        // VisibleScrollViewFrame
        var visibleScrollFrame = self.convertRect(self.bounds, toView: nil)
        visibleScrollFrame = flipLandscapeFrameForIOS7(visibleScrollFrame)
        
        // If keyboard covers part of visibleScrollFrame, cut off visibleScrollFrame
        var bottomOfScrollView = CGRectGetMaxY(visibleScrollFrame)
        if bottomOfScrollView > keyboardRect.origin.y {
            let cutHeight = bottomOfScrollView - keyboardRect.origin.y
            visibleScrollFrame.size.height -= cutHeight
            
            // Animated change self.contentInset
            UIView.animateWithDuration(self.keyboardAnimationDuration, animations: { () -> Void in
                    self.contentInset = UIEdgeInsetsMake(0.0, 0.0, cutHeight, 0.0)
                }, completion: nil)
        }
        
//        // Convert active textField's origin to main window
//        var convertedFrame = flipLandscapeFrameForIOS7(self.activeTextField!.convertRect(self.activeTextField!.bounds, toView: nil))
//        
//        // Enlarge the convertedFrame, give top and bottom 10 points padding
        let offset: CGFloat = 10
//        convertedFrame.origin.y -= offset
//        convertedFrame.size.height += offset * 2
        
//        // If both main window and scrollView don't contain active text field, scroll it
//        if (!CGRectContainsRect(visibleWindowFrame, convertedFrame) && !CGRectContainsRect(visibleScrollFrame, convertedFrame)) {
        
//            var targetFrame = flipLandscapeFrameForIOS7(activeTextField!.convertRect(activeTextField!.bounds, toView: self))
//            
//            // Add top & bottom paddings for target frame
//            targetFrame.origin.y -= offset
//            targetFrame.size.height += offset * 2
//            
//            self.scrollRectToVisible(targetFrame, animated: true)
//        }
        
        
        var targetFrame = flipLandscapeFrameForIOS7(activeTextField!.convertRect(activeTextField!.bounds, toView: self))
        
        // Add top & bottom paddings for target frame
        targetFrame.origin.y -= offset
        targetFrame.size.height += offset * 2
        
        self.scrollRectToVisible(targetFrame, animated: true)
    }
    
    // Helper functions
    func screenHeight() -> CGFloat {
        return UIScreen.mainScreen().bounds.height
    }
    
    func keyboardBeginFrame(notification: NSNotification) -> CGRect {
        let beginFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as AnyObject? as? NSValue)?.CGRectValue()
        return beginFrame as CGRect!
    }
    
    func keyboardEndFrame(notification: NSNotification) -> CGRect {
        let endFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as AnyObject? as? NSValue)?.CGRectValue()
        return endFrame as CGRect!
    }
    
    func isKeyboardWillShow(notification: NSNotification) -> Bool {
        let beginFrame = keyboardBeginFrame(notification)
        return (abs(beginFrame.origin.y - screenHeight()) < 0.1)
    }
    
    func isKeyboardWillHide(notification: NSNotification) -> Bool {
        let endFrame = keyboardEndFrame(notification)
        return (abs(endFrame.origin.y - screenHeight()) < 0.1)
    }
    
    func keyboardDismissingDuration(notification: NSNotification) -> NSTimeInterval {
        return (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as AnyObject? as? NSNumber)?.doubleValue as NSTimeInterval!
    }
    
    func isIOS7() -> Bool { return !isIOS8() }
    func isIOS8() -> Bool { return floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1 }
    
    func isLandscapeMode() -> Bool {
        return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation)
    }
    
    /**
    Flip frame for landscape on iOS7
    Since on landscape on iOS7, CGRect's origin and size is same as portrait, need to flip the rect to let it reflect true widht and height
    
    :param: frame Original CGRect
    
    :returns: Flipped CGRect
    */
    func flipLandscapeFrameForIOS7(frame: CGRect) -> CGRect {
        if !(isIOS7() && isLandscapeMode()) {
            return frame
        } else {
            let newFrame = CGRectMake(frame.origin.y, frame.origin.x, frame.size.height, frame.size.width)
            return newFrame
        }
    }
}


