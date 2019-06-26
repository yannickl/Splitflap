//
//  PlaceholderSymbolConfiguration.swift
//  Splitflap
//
//  Created by Dustin Burge on 6/26/19.
//

import UIKit

public struct PlaceholderSymbolConfiguration {
  public let placeholderSymbol: String
  public let swapSymbol: String
  public let placeholderTextColor: UIColor

  public init(placeholderSymbol: String, swapSymbol: String, placeholderTextColor: UIColor) {
    self.placeholderSymbol = placeholderSymbol
    self.swapSymbol = swapSymbol
    self.placeholderTextColor = placeholderTextColor
  }
}
