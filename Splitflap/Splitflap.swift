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
import QuartzCore

/**
 A split-flap display component that presents changeable alphanumeric text often
 used as a public transport timetable in airports or railway stations and with 
 some flip clocks.
*/
@IBDesignable public class Splitflap: UIView {
  /**
   The data source for the split-flap view.

   The data source must adopt the SplitflapDataSource protocol and implement the
   required methods to return the number of flaps.
  */
  public weak var datasource: SplitflapDataSource?
  public weak var delgate: SplitflapDelegate?

  /**
   Gets the number of flaps for the split-flap view.
   
   A Splitflap object fetches the value of this property from the data source and
   and caches it. The default value is zero.
  */
  public private(set) var numberOfFlaps: Int = 0

  /// The supported token strings by the split-flap view.
  private var tokens: [String] = [] {
    didSet {
      tokenParser = TokenParser(tokens: tokens)
    }
  }

  /// Token parser used to parse text into small chunk send to each flaps.
  private var tokenParser: TokenParser = TokenParser(tokens: [])

  @IBInspectable public var flapSpacing: CGFloat = 0

  @IBInspectable public var animationDuration: Double = 0.2 {
    didSet {
      for flap in flaps {
        flap.animationDuration = animationDuration
      }
    }
  }

  public var text: String? {
    didSet {
      setText(text, animated: false)
    }
  }

  public func setText(text: String?, animated: Bool) {
    let tokens: [String]

    if let t = text, let ts = try? tokenParser.parse(t) {
      tokens = ts
    }
    else {
      tokens = []
    }

    for (index, flap) in flaps.enumerate() {
      let token: String? = index < tokens.count ? tokens[index] : nil

      let delay = animationDuration / 1.1

      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(index) * Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
        flap.displayToken(token, animated: animated)
      })
    }
  }

  private var flaps: [Flap] = [] {
    didSet {
      for flap in oldValue {
        flap.removeFromSuperview()
      }
    }
  }

  // MARK: - Laying out Subviews

  /// Lay out subviews.
  public override func layoutSubviews() {
    super.layoutSubviews()

    let fNumberOfFlaps = CGFloat(numberOfFlaps)
    let widthPerFlap   = (bounds.width - flapSpacing * (fNumberOfFlaps - 1)) / fNumberOfFlaps

    for (index, flap) in flaps.enumerate() {
      let fIndex  = CGFloat(index)
      flap.frame = CGRectMake(fIndex * widthPerFlap + flapSpacing * fIndex, 0, widthPerFlap, bounds.height)
    }
  }

  /// Rebuild and layout the split-flap view.
  private func updateAndLayoutView() {
    var flaps: [Flap] = []

    for _ in 0 ..< numberOfFlaps {
      let flap = Flap()
      flap.tokens            = tokens
      flap.animationDuration = animationDuration

      flaps.append(flap)

      addSubview(flap)
    }

    self.flaps = flaps

    layoutIfNeeded()
  }

  // MARK: - Reloading the Splitflap

  /**
  Reloads the split-flap.
  
  Call this method to reload all the data that is used to construct the split-flap
  view. It should not be called in during a animation.
  */
  public func reload() {
    let receiver = (datasource ?? self)

    numberOfFlaps = receiver.numberOfFlapsInSplitflat(self)
    tokens        = receiver.supportedTokensInSplitflap(self)

    updateAndLayoutView()
  }
}

/// Default implementation of SplitflapDataSource
extension Splitflap: SplitflapDataSource {
  public func numberOfFlapsInSplitflat(splitflap: Splitflap) -> Int {
    return 0
  }
}