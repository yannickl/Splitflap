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
 The TokenParser parses a given string into a token list.
*/
final class TokenParser {
  let tokens: [String: Bool]

  required init(tokens: [String]) {
    // Transforms a list into a dictionary to improve the search
    self.tokens = tokens.reduce([:]) { (dict, elem) in
      var dict   = dict
      dict[elem] = true

      return dict
    }
  }

  // MARK: - Parsing Inputs

  /**
  Parse a given string to find tokens.

  - parameter string: A string to parse.
  - returns: A list of token. An empty list if the given string does not
  contains token.
  */
  func parseString(_ string: String) -> [String] {
    var tokensFound: [String] = []

    var word: String = ""

    for character in string.characters {
      word += String(character)

      if isToken(word) {
        tokensFound.append(word)

        word = ""
      }
    }

    return tokensFound
  }

  // MARK: - Checking Token Validity

  /**
  Checks whether the given word is a token and returns true if it the case.

  - parameter word: A word as String.
  */
  fileprivate func isToken(_ word: String) -> Bool {
    return tokens[word] != nil
  }
}
