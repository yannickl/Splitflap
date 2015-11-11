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

/**
 A Flap view aims to display given tokens with by rotating its tiles to show the
 desired character or graphic.
*/
final class FlapView: UIView {
  // The tiles used to display and animate the flaps
  private let topTicTile: TileView
  private let bottomTicTile: TileView
  private let topTacTile: TileView
  private let bottomTacTile: TileView

  // MARK: - Working With Tokens

  var tokens: [String] = [] {
    didSet {
      tokenGenerator = TokenGenerator(tokens: tokens)
    }
  }
  private var tokenGenerator = TokenGenerator(tokens: [])
  private var targetToken: String?

  // MARK: - Initializing a Flap View

  required init(builder: FlapViewBuilder) {
    topTicTile    = TileView(builder: builder, position: .Top)
    bottomTicTile = TileView(builder: builder, position: .Bottom)
    topTacTile    = TileView(builder: builder, position: .Top)
    bottomTacTile = TileView(builder: builder, position: .Bottom)

    super.init(frame: CGRectZero)

    setupViews()
    setupAnimations()
  }

  required init?(coder aDecoder: NSCoder) {
    let dummyBuilder = FlapViewBuilder { builder in }

    topTicTile    = TileView(builder: dummyBuilder, position: .Top)
    bottomTicTile = TileView(builder: dummyBuilder, position: .Bottom)
    topTacTile    = TileView(builder: dummyBuilder, position: .Top)
    bottomTacTile = TileView(builder: dummyBuilder, position: .Bottom)

    super.init(coder: aDecoder)

    setupViews()
    setupAnimations()
  }

  // MARK: - Laying out Subviews

  override func layoutSubviews() {
    super.layoutSubviews()

    let topLeafFrame    = CGRectMake(0, 0, bounds.width, bounds.height / 2)
    let bottomLeafFrame = CGRectMake(0, bounds.height / 2, bounds.width, bounds.height / 2)

    topTicTile.frame    = topLeafFrame
    bottomTicTile.frame = bottomLeafFrame
    topTacTile.frame    = topLeafFrame
    bottomTacTile.frame = bottomLeafFrame
  }

  // MARK: - Initializing the Flap View

  private func setupViews() {
    addSubview(topTicTile)
    addSubview(bottomTicTile)
    addSubview(topTacTile)
    addSubview(bottomTacTile)

    topTicTile.layer.anchorPoint    = CGPointMake(0.5, 1.0)
    bottomTicTile.layer.anchorPoint = CGPointMake(0.5, 0)
    topTacTile.layer.anchorPoint    = CGPointMake(0.5, 1.0)
    bottomTacTile.layer.anchorPoint = CGPointMake(0.5, 0)

    updateWithToken(tokenGenerator.firstToken, animated: false)
  }

  // MARK: - Settings the Animations

  /// Defines the current time of the animation to know which tile to display.
  private enum AnimationTime {
    /// Tic time.
    case Tic
    /// Tac time.
    case Tac
  }

  private var animationTime = AnimationTime.Tac
  private let topAnim       = CABasicAnimation(keyPath: "transform")
  private let bottomAnim    = CABasicAnimation(keyPath: "transform")

  private func setupAnimations() {
    // Set the perspective
    let zDepth: CGFloat         = 1000
    var skewedIdentityTransform = CATransform3DIdentity
    skewedIdentityTransform.m34 = 1 / -zDepth

    // Predefine the animation
    topAnim.fromValue = NSValue(CATransform3D: skewedIdentityTransform)
    topAnim.toValue   = NSValue(CATransform3D: CATransform3DRotate(skewedIdentityTransform, -CGFloat(M_PI_2), 1, 0, 0))
    topAnim.removedOnCompletion = false
    topAnim.fillMode            = kCAFillModeForwards
    topAnim.timingFunction      = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)

    bottomAnim.fromValue = NSValue(CATransform3D: CATransform3DRotate(skewedIdentityTransform, CGFloat(M_PI_2), 1, 0, 0))
    bottomAnim.toValue   = NSValue(CATransform3D: skewedIdentityTransform)
    bottomAnim.delegate            = self
    bottomAnim.removedOnCompletion = true
    bottomAnim.fillMode            = kCAFillModeBoth
    bottomAnim.timingFunction      = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
  }

  // MARK: - Animating the Flap View

  /**
  Display the given token.
  
  - parameter token: A token string.
  - parameter rotationDuration: If upper than 0, it animates the change.
  */
  func displayToken(token: String?, rotationDuration: Double) {
    let sanitizedToken = token ?? tokenGenerator.firstToken

    if rotationDuration > 0 {
      topAnim.duration    = rotationDuration / 4 * 3
      bottomAnim.duration = rotationDuration / 4

      targetToken = sanitizedToken

      displayNextToken()
    }
    else {
      tokenGenerator.currentElement = sanitizedToken
      
      updateWithToken(sanitizedToken, animated: false)
    }
  }

  /**
  Method used in conjunction with the `animationDidStop:finished:` callback in
  order to display all the tokens between the current one and the target one.
  */
  private func displayNextToken() {
    guard tokenGenerator.currentElement != targetToken else {
      return
    }

    if let token = tokenGenerator.next() {
      updateWithToken(token, animated: true)
    }
  }

  /// Display the given token. If animated it rotate the flaps.
  private func updateWithToken(token: String, animated: Bool) {
    let topBack    = animationTime == .Tic ? topTicTile : topTacTile
    let bottomBack = animationTime == .Tic ? bottomTicTile : bottomTacTile
    let topFront   = animationTime == .Tic ? topTacTile : topTicTile

    topBack.symbol    = token
    bottomBack.symbol = token

    topBack.layer.removeAllAnimations()
    bottomBack.layer.removeAllAnimations()
    topFront.layer.removeAllAnimations()

    if animated {
      bringSubviewToFront(topFront)
      bringSubviewToFront(bottomBack)

      // Animation
      topAnim.beginTime = CACurrentMediaTime()
      topFront.layer.addAnimation(topAnim, forKey: "topDownFlip")

      bottomAnim.beginTime = topAnim.beginTime + topAnim.duration
      bottomBack.layer.addAnimation(bottomAnim, forKey: "bottomDownFlip")
    }
    else {
      bringSubviewToFront(topBack)
      bringSubviewToFront(bottomBack)

      animationTime = animationTime == .Tic ? .Tac : .Tic
    }
  }

  // MARK: - CAAnimation Delegate Methods

  override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
    animationTime = animationTime == .Tic ? .Tac : .Tic
    
    displayNextToken()
  }
}
