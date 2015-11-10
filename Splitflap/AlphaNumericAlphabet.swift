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

class AlphaNumericAlphabet: Alphabet {
  typealias TokenType = String
  typealias Element   = TokenType
  typealias Generator = AnyGenerator<TokenType>

  lazy var alphabets: Array<TokenType> = {
    return " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".characters.map { String($0) }
  }()

  // MARK: -

  func generate() -> Generator {
    var nextIndex = 0

    return anyGenerator {
      if nextIndex < self.alphabets.count {
        return self.alphabets[nextIndex++]
      }

      return nil
    }
  }

  // MARK: -
  private(set) var currentIndex = 0

  func emptyToken() -> TokenType {
    return " "
  }

  var currentElement: Element {
    get {
      return alphabets[currentIndex]
    }
    set(newValue) {
      currentIndex = alphabets.indexOf(newValue) ?? currentIndex
    }
  }

  func next() -> Element? {
    currentIndex = (currentIndex + 1) % alphabets.count

    return alphabets[currentIndex]
  }

  func parse(text: String) throws -> [String] {
    var tokens: [String] = []

    for character in text.characters {
      if alphabets.contains(String(character)) {
        tokens.append(String(character))
      }
      else {
        throw NSError(domain: "com.yannickloriot.token.invalid", code: 999, userInfo: nil)
      }
    }
    
    return tokens
  }
}