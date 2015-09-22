# AutoKeyboardScrollView

[![CI Status](http://img.shields.io/travis/honghaoz/AutoKeyboardScrollView.svg?style=flat)](https://travis-ci.org/Honghao Zhang/AutoKeyboardScrollView)
[![Version](https://img.shields.io/cocoapods/v/AutoKeyboardScrollView.svg?style=flat)](http://cocoapods.org/pods/AutoKeyboardScrollView)
[![License](https://img.shields.io/cocoapods/l/AutoKeyboardScrollView.svg?style=flat)](http://cocoapods.org/pods/AutoKeyboardScrollView)
[![Platform](https://img.shields.io/cocoapods/p/AutoKeyboardScrollView.svg?style=flat)](http://cocoapods.org/pods/AutoKeyboardScrollView)

AutoKeyboardScrollView is a smart UIScrollView which can: 
- Scroll to proper position and make sure the active textField is visible when keyboard is showing 
- Customize top and bottom margin for textField 
- Dismiss keyboard when tap on scrollView 
- Dismiss keyboard on tap "Return" 
- New `contentView` which makes your life with Auto Layout easier

## Preview
![demo](https://raw.githubusercontent.com/honghaoz/AutoKeyboardScrollView/master/demo.gif)

## Why?
Form views are very common when developing iOS projects. When keyboard is showing up, the big keyboard is covering great areas, which will hide the active textField.

It's kind of annoying to handle scrolling on UIScrollView and it's trivial to write keyboard notification and textField target action code again.

To keep your code DRY and make your life with iOS development easier.

## Requirements

- iOS 8.0+ / Mac OS X 10.9+
- Xcode 7.0

## Installation

### CocoaPods
AutoKeyboardScrollView is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod "AutoKeyboardScrollView", '~> 1.4'
```

### Manually

Just drag [`AutoKeyboardScrollView.swift`](https://raw.githubusercontent.com/honghaoz/AutoKeyboardScrollView/master/Source/AutoKeyboardScrollView.swift) (Located in `./Source`, right click and **Download Linked File**) into your project and use it directly.

## Usage
Just use `AutoKeyboardScrollView` as parent view of textFields, or views contain textFields. Add subViews on `autoKeyboardScrollView.contentView` (Be sure to add subViews on `.contentView`), then it just works!

(Note, only textField which is already on the view to be added can be handled, you can manually add textFields that need to be handled by calling `handleTextField:` or `handleTextFields:`)

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## How it works?
`AutoKeyboardScrollView` is a subClass of `UIScrollView`, some key features are list as following:

#### contentView
A new property: `contentView` is added, which is served same purpose as UITableViewCell. All subviews should be added on contentView, this is extremely helpful when dealing Auto Layout with ScrollView (refer: [Apple Technical Note TN2154 - UIScrollView And Autolayout](https://developer.apple.com/library/ios/technotes/tn2154/_index.html))

Note: To let `AutoKeyboardScrollView` determine its `contentSize`, the height and width of `contentView` must be fully specified.

#### Dismiss keyboard on Tap
AutoKeyboardScrollView will be attached with a Tap gesture and let you dismiss keyboard by tapping the empty space around textFields.

#### Dismiss keyboard on "Return"
AutoKeyboardScrollView will automatically detect textFields on newly added subViews, and add UIControlEditing actions for these textField, it will let you dismiss keyboard when tap "Return".

#### Work with Interface Builder
Create a wrapper view in IB, then add it as a subview on `autoKeyboardScrollView.contentView`. 

See example project and select target *InterfaceBuilderExample*:

![targets](https://raw.githubusercontent.com/honghaoz/AutoKeyboardScrollView/master/Example/select_targets.png)

## Requirements
Works with Auto Layout, not tested on frame based code.

Support iOS 7 and above. Not tested on iOS 6, since Auto Layout came from iOS6, should be fine.

## Author

Honghao Zhang (张宏昊) <zhh358@gmail.com>

## License

AutoKeyboardScrollView is available under the MIT license. See the [LICENSE](https://github.com/honghaoz/AutoKeyboardScrollView/blob/master/LICENSE) file for more info.
