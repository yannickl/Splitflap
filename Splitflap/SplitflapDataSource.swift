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
 The SplitflapDataSource protocol must be adopted by an object that mediates
 between a Splitflap object and your application’s data model for that split-flat
 view. The data source provides the split-flat view with the number of flaps for
 displaying the split-flat view data.
*/
public protocol SplitflapDataSource: class {
  /**
   Called by the split-flap view when it needs the number of flaps.
   - parameter splitflat: The split-flap view requesting the data.
   - returns: The number of flaps.
  */
  func numberOfFlapsInSplitflat(splitflap: Splitflap) -> Int

  /**
   Called by the split-flap view when it needs to update the token strings that
   each flaps must display.
   
   If you don't implement this method the split-flap view will use the
   `Alphanumeric` token list.
   - parameter splitflat: The split-flap view requesting the data.
   - returns: A list of token string used as leaf for each flaps.
  */
  func supportedTokensInSplitflap(splitflap: Splitflap) -> [String]
}

// Alternative to optional 
public extension SplitflapDataSource {
  func supportedTokensInSplitflap(splitflap: Splitflap) -> [String] {
    return SplitflapTokens.Alphanumeric
  }
}