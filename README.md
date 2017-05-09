# SugarAnchor

[![CI Status](http://img.shields.io/travis/ashikahmad/SugarAnchor.svg?style=flat)](https://travis-ci.org/ashikahmad/SugarAnchor)
[![Version](https://img.shields.io/cocoapods/v/SugarAnchor.svg?style=flat)](http://cocoapods.org/pods/SugarAnchor)
[![License](https://img.shields.io/cocoapods/l/SugarAnchor.svg?style=flat)](http://cocoapods.org/pods/SugarAnchor)
[![Platform](https://img.shields.io/cocoapods/p/SugarAnchor.svg?style=flat)](http://cocoapods.org/pods/SugarAnchor)

SugarAnchor is syntactic sugar on NSLayoutAnchor to help us write more compact, readable and easy layout code. It wraps up all of NSLayoutXAxisAnchor, NSLayoutYAxisAnchor and NSLayoutDimension functionalities under some easy to use operators to reduce verbosity.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- [x] Xcode 8.3 or above
- [x] Swift 3.1
- [x] iOS 9.0 or above

## Installation

SugarAnchor is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SugarAnchor"
```

## Operator Terminology

Think `~` as **Inactive constraint** and `*` as **Active constraint**. Then with `=*=`, you'll create an active constraint directly or with `=~=` you may create an inactive constraint which you can activate later.

```swift
view1.leftAnchor =*= view2.leftAnchor + 10

// Or

let leftConstraint = (view1.leftAnchor =~= view2.leftAnchor + 10)
leftConstraint.isActive = true
```
In each case, you'll get the constraint to keep or just ignore.

## Author

ashikahmad, ashikcu@gmail.com

## License

SugarAnchor is available under the MIT license. See the LICENSE file for more info.
