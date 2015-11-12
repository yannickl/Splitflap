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
import XCTest

class TokenGeneratorTests: XCTestCase {
  func testCurrentElement() {
    let emptyGenerator = TokenGenerator(tokens: [])
    XCTAssertNil(emptyGenerator.currentElement)

    let oneElementGenerator = TokenGenerator(tokens: ["a"])
    XCTAssertEqual(oneElementGenerator.currentElement, "a")

    let nElementsGenerator = TokenGenerator(tokens: ["a", "b", "c", "d"])
    XCTAssertEqual(nElementsGenerator.currentElement, "a")
  }

  func testNext() {
    let emptyGenerator = TokenGenerator(tokens: [])
    XCTAssertNil(emptyGenerator.currentElement)

    let nilElement = emptyGenerator.next()
    XCTAssertNil(nilElement)
    XCTAssertNil(emptyGenerator.currentElement)

    let oneElementGenerator = TokenGenerator(tokens: ["a"])
    let aElement            = oneElementGenerator.next()
    XCTAssertEqual(aElement, "a")
    XCTAssertEqual(oneElementGenerator.currentElement, "a")

    let twoElementsGenerator = TokenGenerator(tokens: ["a", "b"])
    var twoElement           = twoElementsGenerator.next()
    XCTAssertEqual(twoElement, "b")
    XCTAssertEqual(twoElementsGenerator.currentElement, "b")

    twoElement = twoElementsGenerator.next()
    XCTAssertEqual(twoElement, "a")
    XCTAssertEqual(twoElementsGenerator.currentElement, "a")
  }

  func testFirstToken() {
    let emptyGenerator = TokenGenerator(tokens: [])
    XCTAssertNil(emptyGenerator.firstToken)

    let oneElementGenerator = TokenGenerator(tokens: ["a"])
    XCTAssertEqual(oneElementGenerator.firstToken, "a")

    let nElementsGenerator = TokenGenerator(tokens: ["a", "b", "c", "d"])
    nElementsGenerator.next()
    XCTAssertEqual(nElementsGenerator.firstToken, "a")
  }
}