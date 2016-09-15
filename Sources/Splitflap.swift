/*
 * Splitflap
 *
 * Copyright 2015-present Yannick Loriot.
 * http://yannickloriot.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

import UIKit

/**
 A split-flap display component that presents changeable alphanumeric text often
 used as a public transport timetable in airports or railway stations and with
 some flip clocks.
 */
@IBDesignable open class Splitflap: UIView {
  // MARK: - Specifying the Data Source

  /**
  The data source for the split-flap view.

  The data source must adopt the SplitflapDataSource protocol and implement the
  required methods to return the number of flaps.
  */
  open weak var datasource: SplitflapDataSource?

  // MARK: - Specifying the Delegate

  /**
  The delegate for the split-flap view.
  
  The delegate must adopt the SplitflapDelegate protocol and implement the
  required methods to specify the flap rotation for example.
  */
  open weak var delegate: SplitflapDelegate?

  // MARK: - Getting Flaps

  /**
  Gets the number of flaps for the split-flap view.

  A Splitflap object fetches the value of this property from the data source and
  and caches it. The default value is zero.
  */
  open fileprivate(set) var numberOfFlaps: Int = 0

  /// The flap views used the the split-flap component to display text.
  fileprivate var flaps: [FlapView] = [] {
    didSet {
      for flap in oldValue {
        flap.removeFromSuperview()
      }
    }
  }

  // MARK: - Getting Supported Tokens

  /**
  The supported token strings by the split-flap view.

  A Splitflap object fetches the value of this property from the data source and
  and caches it. By default there is no token.
  */
  open fileprivate(set) var tokens: [String] = [] {
    didSet {
      tokenParser = TokenParser(tokens: tokens)
    }
  }

  /// Token parser used to parse text into small chunk send to each flaps.
  fileprivate var tokenParser: TokenParser = TokenParser(tokens: [])

  // MARK: - Configuring the Flap Spacing

  /**
  Specifies the spacing to use between flaps.

  The default value of this property is 2.0.
  */
  @IBInspectable open var flapSpacing: CGFloat = 2

  // MARK: - Accessing the Text Attributes

  /// The current displayed text.
  fileprivate var textAsToken: String?

  /**
   The text displayed by the split-flap.

   Setting the text with this property is equilavent to call the setText:animated:
   methods with the animated attribute as false. This string is nil by default.

   - seealso: setText:animated:
   */
  open var text: String? {
    get {
      return textAsToken
    }
    set(newValue) {
      setText(newValue, animated: false)
    }
  }

  /**
   Displayed the given text in the split-flap.

   - parameter text: The text to display by the split-flap.
   - parameter animated: *true* to animate the text change by rotating the flaps
   (component) to the new value; if you specify *false*, the new text is shown
   immediately.
   - parameter completionBlock: A block called when the animation did finished. 
   If the text update is not animated the block is called immediately.
   */
  open func setText(_ text: String?, animated: Bool, completionBlock: ((Void) -> Void)? = nil) {
    let completionGroup = DispatchGroup()
    let target          = (delegate ?? self)
    let delay           = animated ? 0.181 : 0

    var tokens: [String] = []

    if let string = text  {
      tokens = tokenParser.parseString(string)
    }

    textAsToken = nil

    for (index, flap) in flaps.enumerated() {
      let token: String?   = index < tokens.count ? tokens[index] : nil
      let rotationDuration = animated ? target.splitflap(self, rotationDurationForFlapAtIndex: index) : 0

      if let t = token {
        textAsToken = textAsToken ?? ""
        textAsToken?.append(t)
      }

      if animated {
        var flapBlock: (() -> ())?

        if completionBlock != nil {
          completionGroup.enter()

          flapBlock = {
            completionGroup.leave()
          }
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(index) * Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
          flap.displayToken(token, rotationDuration: rotationDuration, completionBlock: flapBlock)
        })
      }
      else {
        flap.displayToken(token, rotationDuration: rotationDuration)
      }
    }

    completionGroup.notify(queue: DispatchQueue.main, execute: {
      completionBlock?()
    })
  }

  // MARK: - Observing View-Related Changes

  /// Tells the view that its window object changed.
  open override func didMoveToWindow() {
    reload()
  }

  // MARK: - Laying out Subviews

  /// Lay out subviews.
  open override func layoutSubviews() {
    super.layoutSubviews()

    let fNumberOfFlaps = CGFloat(numberOfFlaps)
    let widthPerFlap   = (bounds.width - flapSpacing * (fNumberOfFlaps - 1)) / fNumberOfFlaps

    for (index, flap) in flaps.enumerated() {
      let fIndex = CGFloat(index)
      flap.frame = CGRect(x: fIndex * widthPerFlap + flapSpacing * fIndex, y: 0, width: widthPerFlap, height: bounds.height)
    }
  }

  /// Rebuild and layout the split-flap view.
  fileprivate func updateAndLayoutView() {
    let targetDelegate = (delegate ?? self)

    var tmp: [FlapView] = []

    for index in 0 ..< numberOfFlaps {
      let flap = FlapView(tokens: tokens, builder: targetDelegate.splitflap(self, builderForFlapAtIndex: index))

      tmp.append(flap)
      addSubview(flap)
    }

    flaps = tmp

    layoutIfNeeded()

    setText(text, animated:  false)
  }

  // MARK: - Reloading the Splitflap

  /**
  Reloads the split-flap.

  Call this method to reload all the data that is used to construct the split-flap
  view. It should not be called in during a animation.
  */
  open func reload() {
    let target = (datasource ?? self)

    numberOfFlaps = target.numberOfFlapsInSplitflap(self)
    tokens        = target.tokensInSplitflap(self)

    updateAndLayoutView()
  }
}

/// Default implementation of SplitflapDataSource
extension Splitflap: SplitflapDataSource {
  /// By default the Splitflap object does not have flaps, so returns 0. 
  public func numberOfFlapsInSplitflap(_ splitflap: Splitflap) -> Int {
    return 0
  }
}

/// Default implementation of SplitflapDelegate
extension Splitflap: SplitflapDelegate {
}
