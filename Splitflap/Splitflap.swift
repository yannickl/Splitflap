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
import QuartzCore

@IBDesignable public class Splitflap: UIView {
  @IBInspectable var wheelCount: Int = 1 {
    didSet {
      var wheels: [Wheel] = []

      for _ in 0 ..< wheelCount {
        wheels.append(Wheel())
      }

      self.wheels = wheels
    }
  }

  @IBInspectable var wheelSpacing: CGFloat = 0

  var animationDuration = Double(0.2) {
    didSet {
      for wheel in wheels {
        wheel.animationDuration = animationDuration
      }
    }
  }

  var alphabet = AlphaNumericAlphabet()
  var text: String? {
    didSet {
      if let t = text, let tokens = try? alphabet.parse(t) {
        for (index, wheel) in wheels.enumerate() {
          let token: String

          if index < tokens.count {
            token = tokens[index]
          }
          else {
            token = alphabet.emptyToken()
          }

          let delay = animationDuration / 1.1

          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(index) * Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            wheel.displayToken(token, animated: true)
          })
        }
      }
    }
  }

  private var wheels: [Wheel] = [] {
    didSet {
      for wheel in oldValue {
        wheel.removeFromSuperview()
      }

      for wheel in wheels {
        addSubview(wheel)
      }

      layoutIfNeeded()
    }
  }

  override public init(frame: CGRect) {
    super.init(frame: frame)
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  public override func layoutSubviews() {
    super.layoutSubviews()

    let fWheelCount   = CGFloat(wheelCount)
    let widthPerWheel = (bounds.width - wheelSpacing * (fWheelCount - 1)) / fWheelCount

    for (index, wheel) in wheels.enumerate() {
      let fIndex  = CGFloat(index)
      wheel.frame = CGRectMake(fIndex * widthPerWheel + wheelSpacing * fIndex, 0, widthPerWheel, bounds.height)
    }
  }
}