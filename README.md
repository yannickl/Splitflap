<p align="center">
  <img src="http://yannickloriot.com/resources/splitflap-logo.gif" alt="Splitflap">
</p>

<p align="center">
  <a href="http://cocoadocs.org/docsets/Splitflap/"><img alt="Supported Platforms" src="https://cocoapod-badges.herokuapp.com/p/Splitflap/badge.svg"/></a>
  <a href="http://cocoadocs.org/docsets/Splitflap/"><img alt="Version" src="https://cocoapod-badges.herokuapp.com/v/Splitflap/badge.svg"/></a>
  <a href="https://github.com/Carthage/Carthage"><img alt="Carthage compatible" src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"/></a>
  <a href="https://travis-ci.org/yannickl/Splitflap"><img alt="Build status" src="https://travis-ci.org/yannickl/Splitflap.svg?branch=master"/></a>
  <a href="http://codecov.io/github/yannickl/Splitflap"><img alt="Code coverage status" src="http://codecov.io/github/yannickl/Splitflap/coverage.svg?branch=master"/></a>
</p>

**Splitflap** is a simple to use component to present changeable alphanumeric text like often used as a public transport timetable in airports or railway stations or with some flip clocks.

*N.B.: This branch is Swift 3 compatible, use the [v1.1.2 version](https://github.com/yannickl/Splitflap/tree/1.1.2) for Swift 2.x.*

## Usage

### Hello World

The first example is the simplest way to use the `Splitflap` component. Here how to display this "Hello" text:

![Hello](http://yannickloriot.com/resources/splitflap-hello.gif)

```swift
import Splitflap

let splitflapView        = Splitflap(frame: CGRect(x: 0, y: 0, width: 370, height: 53))
splitflapView.datasource = self

// Set the text to display by animating the flaps
splitflapView.setText("Hello", animated: true)

// MARK: - Splitflap DataSource Methods

// Defines the number of flaps that will be used to display the text
func numberOfFlapsInSplitflap(_ splitflap: Splitflap) -> Int {
  return 5
}

```

### Theming

`Splitflap` allows you to customize each flap individually by providing a `splitflap:builderForFlapAtIndex:` delegate method:

![Theming](http://yannickloriot.com/resources/splitflap-theming.gif)

```swift
let splitflapView        = Splitflap(frame: CGRect(x: 0, y: 0, width: 370, height: 53))
splitflapView.delegate   = self
splitflapView.datasource = self

// Set the text with an emoji
splitflap.text = "Cat \u{1F63B}"

// MARK: - Splitflap Delegate Methods

// Configure the appearance for each flaps
func splitflap(_ splitflap: Splitflap, builderForFlapAtIndex index: Int) -> FlapViewBuilder {
  return FlapViewBuilder { builder in
    builder.backgroundColor = UIColor(red: 251/255, green: 249/255, blue: 243/255, alpha: 1)
    builder.cornerRadius    = 5
    builder.font            = UIFont(name: "Avenir-Black", size:45)
    builder.textAlignment   = .center
    builder.textColor       = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    builder.lineColor       = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
  }
}

// MARK: - Splitflap DataSource Methods

func tokensInSplitflap(_ splitflap: Splitflap) -> [String] {
  return " Cat\u{1F63B}".characters.map { String($0) }
}
```
### And many more...

To go further, take a look at the documentation and the example project.

*Note: All contributions are welcome*

## Installation

#### CocoaPods

Install CocoaPods if not already available:

``` bash
$ [sudo] gem install cocoapods
$ pod setup
```
Go to the directory of your Xcode project, and Create and Edit your Podfile and add _Splitflap_:

``` bash
$ cd /path/to/MyProject
$ touch Podfile
$ edit Podfile
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

use_frameworks!
pod 'Splitflap', '~> 2.0.0'
```

Install into your project:

``` bash
$ pod install
```

Open your project in Xcode from the .xcworkspace file (not the usual project file):

``` bash
$ open MyProject.xcworkspace
```

You can now `import Splitflap` framework into your files.

#### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate `Splitflap` into your Xcode project using Carthage, specify it in your `Cartfile` file:

```ogdl
github "yannickl/Splitflap" >= 2.0.0
```

#### Swift Package Manager

You can use [The Swift Package Manager](https://swift.org/package-manager) to install `Splitflap` by adding the proper description to your `Package.swift` file:
```swift
import PackageDescription

let package = Package(
    name: "YOUR_PROJECT_NAME",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/yannickl/Splitflap.git", versions: "2.0.0" ..< Version.max)
    ]
)
```

Note that the [Swift Package Manager](https://swift.org/package-manager) is still in early design and development, for more information checkout its [GitHub Page](https://github.com/apple/swift-package-manager).

#### Manually

[Download](https://github.com/YannickL/Splitflap/archive/master.zip) the project and copy the `Splitflap` folder into your project to use it in.

## Contact

Yannick Loriot
 - [https://twitter.com/yannickloriot](https://twitter.com/yannickloriot)
 - [contact@yannickloriot.com](mailto:contact@yannickloriot.com)


## License (MIT)

Copyright (c) 2015-present - Yannick Loriot

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
