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

class SplitflapDelegateTests: XCTTestCaseTemplate {
  func testDefaultImplementation() {
    class DelegateMock: SplitflapDelegate {}

    let delegateMock = DelegateMock()
    let splitflap    = Splitflap()

    XCTAssertEqual(delegateMock.splitflap(splitflap, rotationDurationForFlapAtIndex: 0), 0.2)
  }

  func testCustomImplementation() {
    class DelegateMock: SplitflapDelegate {
      func splitflap(_ splitflap: Splitflap, rotationDurationForFlapAtIndex index: Int) -> Double {
        return 1
      }

      func splitflap(_ splitflap: Splitflap, builderForFlapAtIndex index: Int) -> FlapViewBuilder {
        return FlapViewBuilder { builder in
          builder.backgroundColor = UIColor.red
          builder.cornerRadius    = 0
          builder.font            = UIFont(name: "HelveticaNeue", size: 50)
          builder.textAlignment   = .left
          builder.textColor       = UIColor.yellow
          builder.lineColor       = UIColor.green
        }
      }
    }

    let delegateMock = DelegateMock()
    let splitflap    = Splitflap()

    XCTAssertEqual(delegateMock.splitflap(splitflap, rotationDurationForFlapAtIndex: 0), 1)

    let builder = delegateMock.splitflap(splitflap, builderForFlapAtIndex: 0)
    XCTAssertEqual(builder.backgroundColor, UIColor.red)
    XCTAssertEqual(builder.cornerRadius, 0)
    XCTAssertEqual(builder.font, UIFont(name: "HelveticaNeue", size: 50))
    XCTAssertEqual(builder.textAlignment, NSTextAlignment.left)
    XCTAssertEqual(builder.textColor, UIColor.yellow)
    XCTAssertEqual(builder.lineColor, UIColor.green)
  }
}
