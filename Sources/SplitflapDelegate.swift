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
 The delegate of a Splitflap object should adopt this protocol and implement at
 least some of its methods to provide the split-flap view with the data it needs
 to construct itself.
 */
public protocol SplitflapDelegate: class {
  // MARK: - Setting the Rotation Duration of Flaps

  /**
  Called by the split-flap when it needs to rotate a flap at a given index.

  The default value for each flap is 0.2 seconds.

  - parameter splitflap: The split-flap view requesting the data.
  - parameter index: A zero-indexed number identifying a flap. The index starts
  at 0 for the leftmost flap.
  - returns: The duration of the flap rotation in seconds.
  */
  func splitflap(_ splitflap: Splitflap, rotationDurationForFlapAtIndex index: Int) -> Double

  // MARK: - Configuring the Label of Flaps

  /**
  Called by the split-flap when it needs to create its flap subviews. 

  - parameter splitflap: The split-flap view requesting the data.
  - parameter index: A zero-indexed number identifying a flap. The index starts
  at 0 for the leftmost flap.
  - returns: A FlapView builder object to create custom flaps.
  */
  func splitflap(_ splitflap: Splitflap, builderForFlapAtIndex index: Int) -> FlapViewBuilder
}

/// Default implementation of SplitflapDelegate
public extension SplitflapDelegate {
  /// Returns by default 0.2 seconds.
  func splitflap(_ splitflap: Splitflap, rotationDurationForFlapAtIndex index: Int) -> Double {
    return 0.2
  }

  /// Returns the default FlapViewBuilder configuration by default.
  func splitflap(_ splitflap: Splitflap, builderForFlapAtIndex index: Int) -> FlapViewBuilder {
    return FlapViewBuilder()
  }
}
