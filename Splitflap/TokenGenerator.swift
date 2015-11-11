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
 A TokenGenerator helps the flap view by choosing the right token rescpecting the
 initial order.
*/
final class TokenGenerator: GeneratorType {
  typealias Element = String

  let tokens: [String]

  required init(tokens: [String]) {
    self.tokens = tokens
  }

  // MARK: - Implementing GeneratorType

  private(set) var currentIndex = 0

  var currentElement: Element {
    get {
      return tokens[currentIndex]
    }
    set(newValue) {
      currentIndex = tokens.indexOf(newValue) ?? currentIndex
    }
  }

  func next() -> Element? {
    currentIndex = (currentIndex + 1) % tokens.count

    return tokens[currentIndex]
  }

  // MARK: - Convenience Methods

  var firstToken: String {
    get {
      return tokens.first ?? ""
    }
  }
}