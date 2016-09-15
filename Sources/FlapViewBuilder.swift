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
 The FlapViewBuilder aims to create a simple configuration object for the Flap
 view. It allows you to define the *backgroundColor*, the *font*, the
 *cornerRadius*, etc. It is based on the builder pattern (for more information
 take a look at https://github.com/ochococo/Design-Patterns-In-Swift#-builder)
 */
public final class FlapViewBuilder {
  // MARK: - Customizing Flaps
  
  /**
   The builder block.

   The block gives a reference of builder you can configure.
   */
  public typealias FlapViewBuilderBlock = (_ builder: FlapViewBuilder) -> Void

  /**
   The flap's background color.

   If the value is nil, it results in a transparent background color. The 
   default value is black.
   */
  public var backgroundColor: UIColor? = .black

  /**
   The radius to use when drawing rounded corners for the flap’s background.
   
   Setting the radius to a value greater than 0.0 causes the flap to begin
   drawing rounded corners on its background.

   The default value of this property is 5.0.
   */
  public var cornerRadius: CGFloat = 5

  /**
   The font of the flap.

   If the font is nil, the flap uses its internal default *Courier* font.
   
   The default value of this property is nil.
   */
  public var font: UIFont?

  /**
   The technique to use for aligning the text.
   
   The default value of this property is NSTextAlignment.Center.
  */
  public var textAlignment: NSTextAlignment = .center

  /**
   The color of the text.
   
   Uses the white color by default.
   */
  public var textColor: UIColor = UIColor.white

  /**
   The flap's middle line color.

   If the value is nil, it results in a transparent line color. The default
   value is dark gray.
   */
  public var lineColor: UIColor? = UIColor.darkGray

  // MARK: - Initializing a Flap View

  /**
  Initialize a FlapView builder with default values.
  */
  public init() {}

  /**
   Initialize a FlapView builder with default values.
   
   - parameter buildBlock: A FlapView builder block to configure itself.
   */
  public init(buildBlock: FlapViewBuilderBlock) {
    buildBlock(self)
  }
}
