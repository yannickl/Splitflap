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

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  var i = 0
  @IBAction func updateSplitFlapAction(sender: AnyObject) {
    if i == 0 {
      splitflap.text = "lol"

      i++
    }
    else if i == 1 {
      splitflap.text = "liligo"

      i++
    }
    else if i == 2 {
      splitflap.text = "Azerty"

      i++
    }
    else {
      splitflap.text = "Hey You"

      i = 0
    }
  }
}

