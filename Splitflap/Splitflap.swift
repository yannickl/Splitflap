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
@IBDesignable public class Splitflap: UIView {
  // MARK: - Specifying the Data Source

  /**
  The data source for the split-flap view.

  The data source must adopt the SplitflapDataSource protocol and implement the
  required methods to return the number of flaps.
  */
  public weak var datasource: SplitflapDataSource?

  // MARK: - Specifying the Delegate

  /**
  The delegate for the split-flap view.
  */
  public weak var delgate: SplitflapDelegate?

  // MARK: - Getting Flaps

  /**
  Gets the number of flaps for the split-flap view.

  A Splitflap object fetches the value of this property from the data source and
  and caches it. The default value is zero.
  */
  public private(set) var numberOfFlaps: Int = 0

  /// The flap views used the the split-flap component to display text.
  private var flaps: [FlapView] = [] {
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
  and caches it. The default value is zero.
  */
  public private(set) var tokens: [String] = [] {
    didSet {
      tokenParser = TokenParser(tokens: tokens)
    }
  }

  /// Token parser used to parse text into small chunk send to each flaps.
  private var tokenParser: TokenParser = TokenParser(tokens: [])

  // MARK: - Configuring the Flap Spacing

  /**
  Specifies the spacing to use between flaps.

  The default value of this property is 2.0.
  */
  @IBInspectable public var flapSpacing: CGFloat = 2

  // MARK: - Accessing the Text Attributes

  /// The current displayed text.
  private var textAsToken: String?

  /**
   The text displayed by the split-flap.

   Setting the text with this property is equilavent to call the setText:animated:
   methods with the animated attribute as false. This string is nil by default.

   - seealso: setText:animated:
   */
  public var text: String? {
    get {
      return textAsToken
    }
    set {
      setText(text, animated: false)
    }
  }

  /**
   Displayed the given text in the split-flap.

   - parameter text: The text to display by the split-flap.
   - parameter animated: *true* to animate the text change by rotating the flaps
   (component) to the new value; if you specify *false*, the new text is shown
   immediately.
   */
  public func setText(text: String?, animated: Bool) {
    let target = (delgate ?? self)
    let delay  = animated ? 0.181 : 0

    var tokens: [String] = []

    if let t = text, let ts = try? tokenParser.parse(t) {
      tokens = ts
    }

    textAsToken = nil

    for (index, flap) in flaps.enumerate() {
      let token: String?   = index < tokens.count ? tokens[index] : nil
      let rotationDuration = animated ? target.splitflap(self, rotationDurationForFlapAtIndex: index) : 0

      if let t = token {
        textAsToken = textAsToken ?? ""
        textAsToken?.appendContentsOf(t)
      }

      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(index) * Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
        flap.displayToken(token, rotationDuration: rotationDuration)
      })
    }
  }

  // MARK: - Observing View-Related Changes

  /// Tells the view that its window object changed.
  public override func didMoveToWindow() {
    reload()
  }

  // MARK: - Laying out Subviews

  /// Lay out subviews.
  public override func layoutSubviews() {
    super.layoutSubviews()

    let fNumberOfFlaps = CGFloat(numberOfFlaps)
    let widthPerFlap   = (bounds.width - flapSpacing * (fNumberOfFlaps - 1)) / fNumberOfFlaps

    for (index, flap) in flaps.enumerate() {
      let fIndex = CGFloat(index)
      flap.frame = CGRectMake(fIndex * widthPerFlap + flapSpacing * fIndex, 0, widthPerFlap, bounds.height)
    }
  }

  /// Rebuild and layout the split-flap view.
  private func updateAndLayoutView() {
    let targetDelegate = (delgate ?? self)

    var tmp: [FlapView] = []

    for index in 0 ..< numberOfFlaps {
      let flap    = FlapView(builder: targetDelegate.splitflap(self, builderForFlapAtIndex: index))
      flap.tokens = tokens

      tmp.append(flap)
      addSubview(flap)
    }

    self.flaps = tmp

    layoutIfNeeded()
  }

  // MARK: - Reloading the Splitflap

  /**
  Reloads the split-flap.

  Call this method to reload all the data that is used to construct the split-flap
  view. It should not be called in during a animation.
  */
  public func reload() {
    let target = (datasource ?? self)

    numberOfFlaps = target.numberOfFlapsInSplitflap(self)
    tokens        = target.supportedTokensInSplitflap(self)

    updateAndLayoutView()
  }
}

/// Default implementation of SplitflapDataSource
extension Splitflap: SplitflapDataSource {
  /// By default the Splitflap object does not have flaps, so returns 0. 
  public func numberOfFlapsInSplitflap(splitflap: Splitflap) -> Int {
    return 0
  }
}

/// Default implementation of SplitflapDelegate
extension Splitflap: SplitflapDelegate {
}