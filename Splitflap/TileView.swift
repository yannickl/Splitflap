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

/**
 A Tile is an half view representing the flap's leaf. A tile can represents the
 top or the bottom of a leaf.
*/
final class TileView: UIView {
  fileprivate let digitLabel        = UILabel()
  fileprivate let mainLineView      = UIView()
  fileprivate let secondaryLineView = UIView()

  /// Defines the position and by the same time appearance of the tiles.
  enum Position {
    /// Tile positioned as a top leaf.
    case top
    /// Tile positioned as a bottom leaf.
    case bottom
  }

  let position: Position

  // MARK: - Setting Symbols

  /**
  Set the given symbol as text.
  
  - parameter symbol: An optional symbol string.
  */
  func setSymbol(_ symbol: String?) {
    digitLabel.text = symbol
  }

  // MARK: - Configuring the Label

  /// The font of the tile's text.
  fileprivate var font: UIFont?

  /**
   The radii size to use when drawing rounded corners.
   */
  fileprivate let cornerRadii: CGSize

  // MARK: - Initializing a Flap View

  required init(builder: FlapViewBuilder, position: Position) {
    self.cornerRadii = CGSize(width: builder.cornerRadius, height: builder.cornerRadius)
    self.position    = position

    super.init(frame: CGRect.zero)

    setupViewsWithBuilder(builder)
  }

  required init?(coder aDecoder: NSCoder) {
    cornerRadii = CGSize(width: 0, height: 0)
    position    = .top
    
    super.init(coder: aDecoder)
  }

  // MARK: - Layout the View

  /// Setup the views helping by the given builder.
  fileprivate func setupViewsWithBuilder(_ builder: FlapViewBuilder) {
    font = builder.font

    layer.masksToBounds = true
    backgroundColor     = builder.backgroundColor

    digitLabel.textAlignment   = builder.textAlignment
    digitLabel.textColor       = builder.textColor
    digitLabel.backgroundColor = builder.backgroundColor

    mainLineView.backgroundColor      = builder.lineColor
    secondaryLineView.backgroundColor = builder.backgroundColor

    addSubview(digitLabel)
    addSubview(mainLineView)
    addSubview(secondaryLineView)
  }

  // MARK: - Laying out Subviews

  override func layoutSubviews() {
    super.layoutSubviews()

    // Round corners
    let path: UIBezierPath

    if position == .top {
      path = UIBezierPath(roundedRect:bounds, byRoundingCorners:[.topLeft, .topRight], cornerRadii: cornerRadii)
    }
    else {
      path = UIBezierPath(roundedRect:bounds, byRoundingCorners:[.bottomLeft, .bottomRight], cornerRadii: cornerRadii)
    }

    let maskLayer  = CAShapeLayer()
    maskLayer.path = path.cgPath
    layer.mask     = maskLayer

    // Position elements
    var digitLabelFrame        = bounds
    var mainLineViewFrame      = bounds
    var secondaryLineViewFrame = bounds

    if position == .top {
      digitLabelFrame.size.height = digitLabelFrame.height * 2
      digitLabelFrame.origin.y    = 0
      mainLineViewFrame           = CGRect(x: 0, y: bounds.height - 2, width: bounds.width, height: 4)
      secondaryLineViewFrame      = CGRect(x: 0, y: bounds.height - 1, width: bounds.width, height: 2)
    }
    else {
      digitLabelFrame.size.height = digitLabelFrame.height * 2
      digitLabelFrame.origin.y    = -digitLabelFrame.height / 2
      mainLineViewFrame           = CGRect(x: 0, y: -2, width: bounds.width, height: 3)
      secondaryLineViewFrame      = CGRect(x: 0, y: -2, width: bounds.width, height: 2)
    }

    digitLabel.frame         = digitLabelFrame
    digitLabel.font          = font ?? UIFont(name: "Courier", size: bounds.width)
    mainLineView.frame       = mainLineViewFrame
    secondaryLineView.frame  = secondaryLineViewFrame
  }
}
