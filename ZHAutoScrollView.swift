//
//  ZHAutoScrollView.swift
//
//  Created by Honghao Zhang on 2/1/15.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit

class ZHAutoScrollView: UIScrollView {
    
    // MARK: Public APIs
    
    /**
    Manually add textField to scrollView and let scrollView handle it
    
    :param: textField textField in subView tree of receiver
    */
    func handleTextField(textField: UITextField) {
        (self.contentView as! ZHContentView).addTextField(textField)
    }
    
    /**
    Manually add a bunch of textFields to scrollView and let scrollView handle them
    This is a convenience method
    
    :param: textFields Array of textFields in subView tree of receiver
    */
    func handleTextFields(textFields: [UITextField]) {
        for field in textFields {
            handleTextField(field)
        }
    }
    
    /// Top and Bottom margin for textFiled, this will give an empty spacing between active textField and keyboard
    var topBottomMarginForTextField: CGFloat = 20
    
    /// contentView will has same width scrollView
    var contentViewHasSameWidthWithScrollView: Bool = false {
        didSet {
            if cContentViewWidth == nil {
                return
            }
            self.removeConstraint(cContentViewWidth)
            cContentViewWidth = contentViewConstraintSame(.Width)
            if contentViewHasSameWidthWithScrollView {
                cContentViewWidth.priority = 1000
            } else {
                cContentViewWidth.priority = 10
            }
            self.addConstraint(cContentViewWidth)
        }
    }
    
    /// contentView will has same height scrollView
    var contentViewHasSameHeightWithScrollView: Bool = false {
        didSet {
            if cContentViewHeight == nil {
                return
            }
            self.removeConstraint(cContentViewHeight)
            cContentViewHeight = contentViewConstraintSame(.Height)
            if contentViewHasSameHeightWithScrollView {
                cContentViewHeight.priority = 1000
            } else {
                cContentViewHeight.priority = 10
            }
            self.addConstraint(cContentViewHeight)
        }
    }
    
    // MARK: Private
    private class ZHContentView: UIView {
        var textFields = [UITextField]()
        
        // addSubView will check whether there's textField on this view, be sure to add textField before adding its container View
        override func addSubview(view: UIView) {
            super.addSubview(view)
            if let textField: UITextField = (view as? UITextField) {
                addTextField(textField)
            }
            // Add textFields for subViews
            for subView in view.subviews {
                if let textField: UITextField = (subView as? UITextField) {
                    addTextField(textField)
                }
            }
        }
        
        func addTextField(textField: UITextField) {
            textFields.append(textField)
            setupActionsForTextField(textField)
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
            
            if textField.actionsForTarget(self.superview!, forControlEvent: UIControlEvents.EditingDidEndOnExit) == nil {
                textField.addTarget(self.superview!, action: "_textFiledEditingDidEndOnExit:", forControlEvents: UIControlEvents.EditingDidEndOnExit)
            }
        }
    }
    
    // All subViews should be added on contentView
    // ContentView's size determines contentSize of ScrollView
    // By default, contentView has same size as ScrollView, to expand the contentSize, let subviews' constraints to determin all four edges
    var contentView: UIView!
    var cContentViewWidth: NSLayoutConstraint!
    var cContentViewHeight: NSLayoutConstraint!
    
    // These two values are used to backup original states
    private var originalContentInset: UIEdgeInsets!
    private var originalContentOffset: CGPoint!
    
    // Keep values from UIKeyboardNotification
    private var keyboardFrame: CGRect!
    private var keyboardAnimationDuration: NSTimeInterval!
    
    // TextFields on subtrees for scrollView
    private var textFields: [UITextField] {
        get {
            return (contentView as! ZHContentView).textFields
        }
    }
    
    // Current editing textField
    private var activeTextField: UITextField?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Disable undesired scroll behavior of default UIScrollView
    // To Avoid undesired scroll behavior of default UIScrollView, call myScrollRectToVisible::
    // Reference: http://stackoverflow.com/a/12640831/3164091
    override func scrollRectToVisible(rect: CGRect, animated: Bool) {
        if _expectedScrollRect == nil {
            super.scrollRectToVisible(rect, animated: animated)
            return
        }
        if CGRectEqualToRect(rect, _expectedScrollRect) {
            super.scrollRectToVisible(rect, animated: animated)
        }
    }
    
    private var _expectedScrollRect: CGRect!
    private func myScrollRectToVisible(rect: CGRect, animated: Bool) {
        _expectedScrollRect = rect
        self.scrollRectToVisible(rect, animated: animated)
    }
    
    // MARK: Setups
    private func setup() {
        setupContentView()
        setupGestures()
        registerNotifications()
    }
    
    private func setupContentView() {
        contentView = ZHContentView()
        contentView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(contentView)
        
        let top = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0)
        let left = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0.0)
        let bottom = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0)
        let right = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0.0)
        
        // Width and height constraints with a lower priority
        cContentViewWidth = contentViewConstraintSame(.Width)
        // If sameWidth is not required, set its priority to a low value
        if !contentViewHasSameWidthWithScrollView {
            // Set its priority to be a very low value, to avoid conflicts
            cContentViewWidth.priority = 10
        }
        cContentViewHeight = contentViewConstraintSame(.Height)
        if !contentViewHasSameHeightWithScrollView {
            cContentViewHeight.priority = 10
        }
        self.addConstraints([top, left, bottom, right, cContentViewWidth, cContentViewHeight])
    }
    
    func contentViewConstraintSame(attr: NSLayoutAttribute) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: contentView, attribute: attr, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: self, attribute: attr, multiplier: 1.0, constant: 0.0)
    }
    
    deinit {
        unregisterNotifications()
    }
}

// MARK: TapGesture - Tap to dismiss
extension ZHAutoScrollView {
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: "selfIsTapped:")
        tapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGesture)
    }
    
    func selfIsTapped(gesture: UITapGestureRecognizer) {
        activeTextField?.resignFirstResponder()
    }
}

// MARK: TextFields Actions
extension ZHAutoScrollView {
    func _textFiledEditingDidBegin(sender: AnyObject) {
        activeTextField = sender as? UITextField
        if self.keyboardFrame != nil {
            makeActiveTextFieldVisible(self.keyboardFrame)
        }
    }
    
    func _textFiledEditingChanged(sender: AnyObject) {
        if self.keyboardFrame != nil {
            makeActiveTextFieldVisible(self.keyboardFrame)
        }
    }
    
    func _textFiledEditingDidEnd(sender: AnyObject) {
        //
    }
    
    func _textFiledEditingDidEndOnExit(sender: AnyObject) {
        //
    }
}

// MARK: Keyboard Notification
extension ZHAutoScrollView {
    private func registerNotifications() {
        // Reason for only registering UIKeyboardWillChangeFrameNotification
        // Since UIKeyboardWillChangeFrameNotification will be posted before willShow and willBeHidden, to avoid duplicated animations, detecting keyboard behaviors only from this notification
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "keyboardWillChange:",
            name: UIKeyboardWillChangeFrameNotification,
            object: nil)
    }
    
    private func unregisterNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    func keyboardWillChange(notification: NSNotification) {
        // Init keyboardAnimationDuration
        self.keyboardAnimationDuration = keyboardDismissingDuration(notification)
        
        if isKeyboardWillShow(notification) {
            // Preserved original contentInset and contentOffset
            self.originalContentInset = self.contentInset
            self.originalContentOffset = self.contentOffset
            
            let endFrame = keyboardEndFrame(notification)
            // Init keyboardFrame
            self.keyboardFrame = endFrame
            
            makeActiveTextFieldVisible(endFrame)
        } else if isKeyboardWillHide(notification) {
            // Animated to restore to original state
            UIView.animateWithDuration(keyboardDismissingDuration(notification), animations: { () -> Void in
                self.contentInset = self.originalContentInset ?? UIEdgeInsetsZero
                self.contentOffset = self.originalContentOffset ?? CGPointZero
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
    private func makeActiveTextFieldVisible(var keyboardRect: CGRect) {
        if activeTextField == nil { return }
        // flipLandscapeFrameForIOS7 only changes CGRect for landscape on iOS7
        keyboardRect = flipLandscapeFrameForIOS7(keyboardRect)
        
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
        
        // Enlarge the targetFrame, give top and bottom some points margin
        var targetFrame = flipLandscapeFrameForIOS7(activeTextField!.convertRect(activeTextField!.bounds, toView: self))
        
        // Add top & bottom margins for target frame
        targetFrame.origin.y -= topBottomMarginForTextField
        targetFrame.size.height += topBottomMarginForTextField * 2
        
        // Don't call default scrollRectToVisible
        self.myScrollRectToVisible(targetFrame, animated: true)
    }
    
    // Helper functions
    private func screenHeight() -> CGFloat {
        return UIScreen.mainScreen().bounds.height
    }
    
    private func keyboardBeginFrame(notification: NSNotification) -> CGRect {
        let beginFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as AnyObject? as? NSValue)?.CGRectValue()
        return beginFrame as CGRect!
    }
    
    private func keyboardEndFrame(notification: NSNotification) -> CGRect {
        let endFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as AnyObject? as? NSValue)?.CGRectValue()
        return endFrame as CGRect!
    }
    
    private func isKeyboardWillShow(notification: NSNotification) -> Bool {
        let beginFrame = keyboardBeginFrame(notification)
        return (abs(beginFrame.origin.y - screenHeight()) < 0.1)
    }
    
    private func isKeyboardWillHide(notification: NSNotification) -> Bool {
        let endFrame = keyboardEndFrame(notification)
        return (abs(endFrame.origin.y - screenHeight()) < 0.1)
    }
    
    private func keyboardDismissingDuration(notification: NSNotification) -> NSTimeInterval {
        return (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as AnyObject? as? NSNumber)?.doubleValue as NSTimeInterval!
    }
    
    private func isIOS7() -> Bool { return !isIOS8() }
    private func isIOS8() -> Bool { return floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1 }
    
    private func isLandscapeMode() -> Bool {
        return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation)
    }
    
    /**
    Flip frame for landscape on iOS7
    Since on landscape on iOS7, CGRect's origin and size is same as portrait, need to flip the rect to let it reflect true widht and height
    
    :param: frame Original CGRect
    
    :returns: Flipped CGRect
    */
    private func flipLandscapeFrameForIOS7(frame: CGRect) -> CGRect {
        if !(isIOS7() && isLandscapeMode()) {
            return frame
        } else {
            let newFrame = CGRectMake(frame.origin.y, frame.origin.x, frame.size.height, frame.size.width)
            return newFrame
        }
    }
}
