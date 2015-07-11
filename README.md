# AutoKeyboardScrollView
AutoKeyboardScrollView is a smart UIScrollView which can: - Scroll to proper position and make sure the active textField is visible when keyboard is showing - Customize top and bottom margin for textField - Dismiss keyboard when tap on scrollView - Dismiss keyboard on tap "Return" - Added `contentView` and make your life with Auto Layout easier

# Preview
![demo](https://raw.githubusercontent.com/honghaoz/AutoKeyboardScrollView/master/demo.gif)

# Why?
Form views are very common when developing iOS projects. When keyboard is showing up, the big keyboard is covering great areas, which will hide the active textField.

It's kind of annoying to handle scrolling on UIScrollView and it's trivial to write keyboard notification and textField target action code again.

To keep your code DRY and make your life with iOS development easier.

# Usage
Just use `AutoKeyboardScrollView` as parent view of textFields, or views contain textFields. Add subViews on `autoKeyboardScrollView.contentView` (Be sure to add subViews on `.contentView`), then it just works!

(Note, only textField which is already on the view to be added can be handled, you can manually add textFields that need to be handled by calling `handleTextField:` or `handleTextFields:`)

# How it works?
`AutoKeyboardScrollView` is a subClass of `UIScrollView`, some key features are list as following:

## contentView
A new property: `contentView` is added, which is served same purpose as UITableViewCell. All subviews should be added on contentView, this is extremely helpful when dealing Auto Layout with ScrollView (refer: [Apple Technical Note TN2154 - UIScrollView And Autolayout](https://developer.apple.com/library/ios/technotes/tn2154/_index.html))

Note: To let `AutoKeyboardScrollView` determine its `contentSize`, the height and width of `contentView` must be fully specified.

## Dismiss keyboard on Tap
AutoKeyboardScrollView will be attached with a Tap gesture and let you dismiss keyboard by tapping the empty space around textFields.

## Dismiss keyboard on "Return"
AutoKeyboardScrollView will automatically detect textFields on newly added subViews, and add UIControlEditing actions for these textField, it will let you dismiss keyboard when tap "Return".

# Compatibility
Works with Auto Layout, not tested on frame based code.

Support iOS 8 and above. Not tested on iOS 6 and iOS 7, since Auto Layout came from iOS6, should be fine.

# The MIT License (MIT)
The MIT License (MIT)

Copyright (c) 2015 Honghao Zhang 张宏昊

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
