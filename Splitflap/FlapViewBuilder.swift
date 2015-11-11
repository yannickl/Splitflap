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
  /**
   The builder block.

   The block gives a reference of builder you can configure.
   */
  public typealias FlapViewBuilderBlock = (builder: FlapViewBuilder) -> ()

  /**
   The flap's background color.

   The value is nil, it results in a transparent background color. The default value is black.
   */
  var backgroundColor: UIColor? = UIColor.blackColor()

  /**
   The font of the flap.

   If the font is nil, the flap uses its internal default *Courier* font.
   */
  var font: UIFont?

  /**
   The color of the text.
   */
  var textColor: UIColor = UIColor.whiteColor()

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
    buildBlock(builder: self)
  }
}