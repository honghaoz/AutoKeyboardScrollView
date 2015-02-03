# ZHAutoScrollView
ZHAutoScrollView is a smart UIScrollView which can handle keyboard covering UITextField issues.

# Why?
Form views are very common when developing iOS projects. When keyboard is showing up, the big keyboard is covering great areas, which will hide the active textField. 

It's kind of annoying to handle scrolling on UIScrollView and it's trivial to write keyboard notification and textField target action code again. 

To keep your code DRY and make your life with iOS development easier.

# Preview

![demo](https://raw.githubusercontent.com/honghaoz/ZHAutoScrollView/master/Demo/demo.gif)

# Usage

Just use `ZHAutoScrollView` as parent view for textFields, or views contain textFields. Add subViews on `zhAutoScrollView.contentView`, then that's it!

(Note, only textField which is already on the view to be added can be handled, you can manualy add textField by calling `addTextField:`)


# How it works?

`ZHAutoScrollView` is a subClass of `UIScrollView`, some key features are list as following:

#### contentView
A new property: `contentView` is added, which is served same purpose as UITableViewCell. All subviews should be added on contentView, this is extremely helpful when dealing Auto Layout with ScrollView (refer: [Apple Technical Note TN2154 - UIScrollView And Autolayout](https://developer.apple.com/library/ios/technotes/tn2154/_index.html))

To let `ZHAutoScrollView` determine `contentSize`, let constraints on `contentView` covers its four edges, so size of `contentView` is `contentSize`.

#### Dismiss keyboard on Tap
ZHAutoScrollView will be attached with a Tap gesture and let you dismiss keyboard by tapping the empty space around textFields.

#### Dismiss keyboard on "Return"
ZHAutoScrollView will automatically detect textFields on newly added subViews, and add UIControlEditing actions for these textField, it will let you dismiss keyboard when tap "Return".

# Compatibility

Works with Auto Layout, not tested on frame based code.

Support iOS7 and above. Not tested on iOS6, since iOS6 support autolayout, should work.

