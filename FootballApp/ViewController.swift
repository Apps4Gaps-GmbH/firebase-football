//
//  ViewController.swift
//  FootballApp
//
//  Created by Tomer Ciucran on 2/3/16.
//  Copyright © 2016 Apps4Gaps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var invisibleLayer: UIView! {
        didSet {
            let gesture = UITapGestureRecognizer(target: self, action: "goToCountries:")
            invisibleLayer.addGestureRecognizer(gesture)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    func goToCountries(sender:UIView) {
        self.performSegueWithIdentifier("fromWelcomeToCountries", sender: sender)
    }

}

