//
//  ViewController.swift
//  SplitflapExample
//
//  Created by Yannick LORIOT on 10/11/15.
//  Copyright © 2015 Yannick LORIOT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var splitflap: Splitflap!
  @IBOutlet weak var actionButton: UIButton!

  private let words        = ["Hey You", "Bonsoir", "12h15", "Arrival"]
  private var currentIndex = 0

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    updateSplitFlapAction(actionButton)
  }

  // MARK: - Action Methods

  @IBAction func updateSplitFlapAction(sender: AnyObject) {
    splitflap.setText(words[currentIndex], animated: true)

    currentIndex = (currentIndex + 1) % words.count

    updateButtonWithTitle(words[currentIndex])
  }

  private func updateButtonWithTitle(title: String) {
    actionButton.setTitle("Say \(words[currentIndex])!", forState: .Normal)
  }
}

