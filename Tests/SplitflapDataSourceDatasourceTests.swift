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

class SplitflapDataSourceDatasourceTests: XCTTestCaseTemplate {
  func testDefaultImplementation() {
    class DataSourceMock: SplitflapDataSource {
      func numberOfFlapsInSplitflap(_ splitflap: Splitflap) -> Int {
        return 0
      }
    }

    let datasourceMock = DataSourceMock()
    let splitflap      = Splitflap()

    XCTAssertEqual(datasourceMock.numberOfFlapsInSplitflap(splitflap), 0)
    XCTAssertEqual(datasourceMock.tokensInSplitflap(splitflap, flap:0), SplitflapTokens.Alphanumeric)
  }

  func testCustomImplementation() {
    class DataSourceMock: SplitflapDataSource {
      func numberOfFlapsInSplitflap(_ splitflap: Splitflap) -> Int {
        return 5
      }

        func tokensInSplitflap(_ splitflap: Splitflap, flap: Int) -> [String] {
        return SplitflapTokens.Numeric
      }
    }

    let datasourceMock = DataSourceMock()
    let splitflap      = Splitflap()

    XCTAssertEqual(datasourceMock.numberOfFlapsInSplitflap(splitflap), 5)
    XCTAssertEqual(datasourceMock.tokensInSplitflap(splitflap, flap:0), SplitflapTokens.Numeric)
  }
}
