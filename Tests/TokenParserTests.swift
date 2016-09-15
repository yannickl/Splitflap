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

class TokenParserTests: XCTTestCaseTemplate {
  func testParseEmptyString() {
    let parser = TokenParser(tokens: [])

    XCTAssertEqual(parser.parseString(""), [])
    XCTAssertEqual(parser.parseString(" "), [])
    XCTAssertEqual(parser.parseString("hello"), [])
  }

  func testParseOneSimpleTokenString() {
    let parser = TokenParser(tokens: ["a"])

    XCTAssertEqual(parser.parseString(""), [])
    XCTAssertEqual(parser.parseString("hello"), [])
    XCTAssertEqual(parser.parseString("a"), ["a"])
    XCTAssertEqual(parser.parseString("aaaaa"), ["a", "a", "a", "a", "a"])
    XCTAssertEqual(parser.parseString("abracadabra"), ["a"])
    XCTAssertEqual(parser.parseString("ba_alababa"), [])
  }

  func testParseAlphabeticTokenString() {
    let parser = TokenParser(tokens: SplitflapTokens.Alphabetic)

    XCTAssertEqual(parser.parseString(""), [])
    XCTAssertEqual(parser.parseString("hello"), ["h", "e", "l", "l", "o"])
    XCTAssertEqual(parser.parseString("Hello"), ["H", "e", "l", "l", "o"])
    XCTAssertEqual(parser.parseString("h0ello"), ["h"])
    XCTAssertEqual(parser.parseString(" hello"), [])
  }

  func testParseOneComplexTokenString() {
    let parser = TokenParser(tokens: ["foo"])

    XCTAssertEqual(parser.parseString(""), [])
    XCTAssertEqual(parser.parseString("f"), [])
    XCTAssertEqual(parser.parseString("fo"), [])
    XCTAssertEqual(parser.parseString("foo"), ["foo"])
    XCTAssertEqual(parser.parseString("foof"), ["foo"])
    XCTAssertEqual(parser.parseString("foofo"), ["foo"])
    XCTAssertEqual(parser.parseString("foofoo"), ["foo", "foo"])
    XCTAssertEqual(parser.parseString("footfoo"), ["foo"])
    XCTAssertEqual(parser.parseString("playfoot"), [])
  }

  func testParseComplexTokenString() {
    let parser = TokenParser(tokens: ["foo", "bar", "pop"])

    XCTAssertEqual(parser.parseString(""), [])
    XCTAssertEqual(parser.parseString("foo"), ["foo"])
    XCTAssertEqual(parser.parseString("foopop"), ["foo", "pop"])
    XCTAssertEqual(parser.parseString("popbarfoopop"), ["pop", "bar", "foo", "pop"])
    XCTAssertEqual(parser.parseString("afoo"), [])
  }
}