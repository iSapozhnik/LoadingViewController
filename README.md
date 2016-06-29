# LoadingViewController

[![CI Status](http://img.shields.io/travis/Sapozhnik Ivan/LoadingViewController.svg?style=flat)](https://travis-ci.org/Sapozhnik Ivan/LoadingViewController)
[![Version](https://img.shields.io/cocoapods/v/LoadingViewController.svg?style=flat)](http://cocoapods.org/pods/LoadingViewController)
[![License](https://img.shields.io/cocoapods/l/LoadingViewController.svg?style=flat)](http://cocoapods.org/pods/LoadingViewController)
[![Platform](https://img.shields.io/cocoapods/p/LoadingViewController.svg?style=flat)](http://cocoapods.org/pods/LoadingViewController)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

LoadingViewController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "LoadingViewController"
```

Currently it supporting UIViewControllers but not UITableViewController and UICollectionViewController. 

## How to use

Subclass your controller from LoadingViewController. On the top of View of your controller put another UIView which will be content view. All your content should be on the top of Content view. Link *contentView* property with this newly created view.

```javascript
override func viewDidLoad() {
super.viewDidLoad()

// Do any additional setup after loading the view, typically from a nib.

delay(3.0) { [weak self] in
self?.setVisibleScreen(.Loading)
self?.delay(3, closure: { [weak self] in
self?.setVisibleScreen(.Content)
})
}
}
```

## TODO
* add support of UITableViewController and UICollectionViewController
* implement NoData view, Error view, Empty view

## Author

Sapozhnik Ivan, sapozhnik.ivan@gmail.com

## License

LoadingViewController is available under the MIT license. See the LICENSE file for more info.
