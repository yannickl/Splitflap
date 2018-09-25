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
final class FlapView: UIView, CAAnimationDelegate {
  // The tiles used to display and animate the flaps
  fileprivate let topTicTile: TileView
  fileprivate let bottomTicTile: TileView
  fileprivate let topTacTile: TileView
  fileprivate let bottomTacTile: TileView

  // MARK: - Working With Tokens

  let tokens: [String]
  fileprivate let tokenGenerator:TokenGenerator
  fileprivate var targetToken: String?
  fileprivate var targetCompletionBlock: (() -> ())? {
    didSet {
      oldValue?()
    }
  }

  // MARK: - Initializing a Flap View

  required init(tokens: [String], builder: FlapViewBuilder) {
    self.topTicTile    = TileView(builder: builder, position: .top)
    self.bottomTicTile = TileView(builder: builder, position: .bottom)
    self.topTacTile    = TileView(builder: builder, position: .top)
    self.bottomTacTile = TileView(builder: builder, position: .bottom)

    self.tokens         = tokens
    self.tokenGenerator = TokenGenerator(tokens: tokens)

    super.init(frame: CGRect.zero)

    setupViews()
    setupAnimations()
  }

  required init?(coder aDecoder: NSCoder) {
    topTicTile     = TileView(builder: FlapViewBuilder(), position: .top)
    bottomTicTile  = TileView(builder: FlapViewBuilder(), position: .bottom)
    topTacTile     = TileView(builder: FlapViewBuilder(), position: .top)
    bottomTacTile  = TileView(builder: FlapViewBuilder(), position: .bottom)
    tokens         = []
    tokenGenerator = TokenGenerator(tokens: [])
    
    super.init(coder: aDecoder)
  }

  // MARK: - Laying out Subviews

  override func layoutSubviews() {
    super.layoutSubviews()

    let topLeafFrame    = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height / 2)
    let bottomLeafFrame = CGRect(x: 0, y: bounds.height / 2, width: bounds.width, height: bounds.height / 2)

    topTicTile.frame    = topLeafFrame
    bottomTicTile.frame = bottomLeafFrame
    topTacTile.frame    = topLeafFrame
    bottomTacTile.frame = bottomLeafFrame
  }

  // MARK: - Initializing the Flap View

  fileprivate func setupViews() {
    addSubview(topTicTile)
    addSubview(bottomTicTile)
    addSubview(topTacTile)
    addSubview(bottomTacTile)

    topTicTile.layer.anchorPoint    = CGPoint(x: 0.5, y: 1.0)
    bottomTicTile.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
    topTacTile.layer.anchorPoint    = CGPoint(x: 0.5, y: 1.0)
    bottomTacTile.layer.anchorPoint = CGPoint(x: 0.5, y: 0)

    updateWithToken(tokenGenerator.firstToken, animated: false)
  }

  // MARK: - Settings the Animations

  /// Defines the current time of the animation to know which tile to display.
  fileprivate enum AnimationTime {
    /// Tic time.
    case tic
    /// Tac time.
    case tac
  }

  fileprivate var animationTime = AnimationTime.tac
  fileprivate let topAnim       = CABasicAnimation(keyPath: "transform")
  fileprivate let bottomAnim    = CABasicAnimation(keyPath: "transform")

  fileprivate func setupAnimations() {
    // Set the perspective
    let zDepth: CGFloat         = 1000
    var skewedIdentityTransform = CATransform3DIdentity
    skewedIdentityTransform.m34 = 1 / -zDepth

    // Predefine the animation
    topAnim.fromValue = NSValue(caTransform3D: skewedIdentityTransform)
    topAnim.toValue   = NSValue(caTransform3D: CATransform3DRotate(skewedIdentityTransform, CGFloat.pi / -2, 1, 0, 0))
    topAnim.isRemovedOnCompletion = false
    topAnim.fillMode              = CAMediaTimingFillMode.forwards
    topAnim.timingFunction        = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)

    bottomAnim.fromValue = NSValue(caTransform3D: CATransform3DRotate(skewedIdentityTransform, CGFloat.pi / 2, 1, 0, 0))
    bottomAnim.toValue   = NSValue(caTransform3D: skewedIdentityTransform)
    bottomAnim.delegate              = self
    bottomAnim.isRemovedOnCompletion = true
    bottomAnim.fillMode              = CAMediaTimingFillMode.both
    bottomAnim.timingFunction        = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
  }

  // MARK: - Animating the Flap View

  /**
  Display the given token.
  
  - parameter token: A token string.
  - parameter rotationDuration: If upper than 0, it animates the change.
  - parameter completionBlock: A block called when the animation did finished.
  If the text update is not animated the block is called immediately.
  */
  func displayToken(_ token: String?, rotationDuration: Double, completionBlock: (() -> Void)? = nil) {
    let sanitizedToken = token ?? tokenGenerator.firstToken

    if rotationDuration > 0 {
      topAnim.duration    = rotationDuration / 4 * 3
      bottomAnim.duration = rotationDuration / 4

      let animating = targetToken != nil

      targetToken           = sanitizedToken
      targetCompletionBlock = completionBlock

      if !animating {
        displayNextToken()
      }
    }
    else {
      tokenGenerator.currentElement = sanitizedToken
      
      updateWithToken(sanitizedToken, animated: false)

      completionBlock?()
    }
  }

  /**
  Method used in conjunction with the `animationDidStop:finished:` callback in
  order to display all the tokens between the current one and the target one.
  */
  fileprivate func displayNextToken() {
    guard tokenGenerator.currentElement != targetToken && targetToken != nil else {
      targetToken           = nil
      targetCompletionBlock = nil

      return
    }

    if let token = tokenGenerator.next() {
      updateWithToken(token, animated: true)
    }
  }

  /// Display the given token. If animated it rotate the flaps.
  fileprivate func updateWithToken(_ token: String?, animated: Bool) {
    let topBack    = animationTime == .tic ? topTicTile : topTacTile
    let bottomBack = animationTime == .tic ? bottomTicTile : bottomTacTile
    let topFront   = animationTime == .tic ? topTacTile : topTicTile

    topBack.setSymbol(token)
    bottomBack.setSymbol(token) 

    topBack.layer.removeAllAnimations()
    bottomBack.layer.removeAllAnimations()
    topFront.layer.removeAllAnimations()

    if animated {
      bringSubviewToFront(topFront)
      bringSubviewToFront(bottomBack)

      // Animation
      topAnim.beginTime = CACurrentMediaTime()
      topFront.layer.add(topAnim, forKey: "topDownFlip")

      bottomAnim.beginTime = topAnim.beginTime + topAnim.duration
      bottomBack.layer.add(bottomAnim, forKey: "bottomDownFlip")
    }
    else {
      bringSubviewToFront(topBack)
      bringSubviewToFront(bottomBack)

      animationTime = animationTime == .tic ? .tac : .tic
    }
  }

  // MARK: - CAAnimation Delegate Methods

  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    animationTime = animationTime == .tic ? .tac : .tic
    
    displayNextToken()
  }
}
