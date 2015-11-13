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

class SplitflapTests: XCTTestCaseTemplate {
  func testDefaultSplitflap() {
    let splitflap = Splitflap()

    XCTAssertNil(splitflap.datasource)
    XCTAssertNil(splitflap.delegate)
    XCTAssertEqual(splitflap.numberOfFlaps, 0)
    XCTAssertEqual(splitflap.tokens, [])
    XCTAssertEqual(splitflap.flapSpacing, 2)
    XCTAssertNil(splitflap.text)
  }

  func testText() {
    class DataSourceMock: SplitflapDataSource {
      func numberOfFlapsInSplitflap(splitflap: Splitflap) -> Int {
        return 5
      }
    }

    let datasourceMock   = DataSourceMock()
    let splitflap        = Splitflap()
    splitflap.datasource = datasourceMock
    splitflap.reload()
    
    XCTAssertNil(splitflap.text)

    splitflap.text = "hello"
    XCTAssertEqual(splitflap.text, "hello")

    splitflap.text = "helloworld"
    XCTAssertEqual(splitflap.text, "hello")

    splitflap.text = "$invalid!"
    XCTAssertEqual(splitflap.text, nil)
  }
}