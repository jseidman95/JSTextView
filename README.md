# JSTextView

## Introduction

This Cocoapod provides a TextView that automatically generates text tags based on NSAttributedString attributes and allows the user to 'Jump Scroll' through the tags by holding the side of the screen and scrolling.  This pod is project with textviews that contain large amount of text.

## Code Samples

Any NSAttributedStringKey can be used to create text tags:
NSAttributedStringKey.font:
```swift
textView.appendToLabelArray(attributeName: NSAttributedStringKey.font, attributeValue: UIFont(name: "Times New Roman", size: 43.0)!)
```
NSAttributedStringKey.foregroundColor
```swift
textView.appendToLabelArray(attributeName: NSAttributedStringKey.foregroundColor,
attributeValue: UIColor(red: 217/255.0,
green: 80/255.0,
blue: 0/255.0,
alpha: 1.0))
```
NSAttributedStringKey.foregroundColor
```swift
textView.appendToLabelArray(attributeName: NSAttributedStringKey.underlineStyle,
attributeValue: NSUnderlineStyle.styleSingle.rawValue)
```

JSTextView also includes many customizable features <n>
Set custom screen percentage for the jump scroll to be active in:
```swift
textView.jumpPressEdgePercentage = 0.2
```
Set the distance of the text of the jumped label from the top of the screen:
```swift
textView.jumpTextDistanceFromTop = 40.0
```
Set the distance text of the jump label from the edge of the screen
```swift
textView.labelTextDistanceFromEdge = 100.0
```
Set the color of the jump label text
```swift
textView.jumpLabelTextColor = UIColor.blue
```
Set the size of the jump label font
```swift
textView.jumpLabelFont = UIFont.systemFont(ofSize: 30.0)
```
Set the side which the jump label is presented and triggered
```swift
textView.jumpPressEdgeSide = .right
```
Set the color of the jump label
```swift
textView.jumpLabelColor = UIColor.black
```
Hide/show the scroll indicator while the user is jumping
```swift
textView.showsIndicatorOnJump = false
```
Change the amount of time the user needs to hold on the edge of the screen to present the jump label
```swift
textView.jumpLabelPresentDuration = 0.1
```

## Installation

To install simply include pod 'JSTextView' in your podfile and run pod install.
