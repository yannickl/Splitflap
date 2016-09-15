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

import Foundation

/**
 The SplitflapTokens defines a collection of token string ready to use for 
 split-flap view.
 
 A token is a character, a symbol or a text that is displays by the flap view. A
 flap view manages a stack a token in order to display them in the good order when
 it needs to animate its token change.
*/
open class SplitflapTokens {
  /// Numeric characters.
  open static let Numeric = (0 ... 9).map { String($0) }

  /// Alphabetic characters (lower and upper cases).
  open static let Alphabetic = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".characters.map { String($0) }

  /// Combination of alphabetic (lower and upper cases) and numeric characters.
  open static let Alphanumeric = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".characters.map { String($0) }

  /// Combination of alphabetic (lower and upper cases) and numeric characters plus the space.
  open static let AlphanumericAndSpace = " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".characters.map { String($0) }

  /// The 12-hour clock characters (from 1 to 12).
  open static let TwelveHourClock = (1 ... 12).map { String($0) }

  /// The 24-hour clock characters (from 00 to 23).
  open static let TwentyFourHourClock = (0 ... 23).map { String(format:"%02d", $0) }

  /// The minute/second characters (from 00 to 59).
  open static let MinuteAndSecond = (0 ... 59).map { String(format:"%02d", $0) }
}
