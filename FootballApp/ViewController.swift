//
//  ViewController.swift
//  FootballApp
//
//  Created by Tomer Ciucran on 2/3/16.
//  Copyright © 2016 Apps4Gaps. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var invisibleLayer: UIView! {
        didSet {
            let gesture = UITapGestureRecognizer(target: self, action: "goToCountries")
            invisibleLayer.addGestureRecognizer(gesture)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func goToCountries() {
        self.performSegueWithIdentifier("fromWelcomeToCountries", sender:self)
    }
    
    
//    var favouriteTeam: String?
//    override func viewWillAppear(animated: Bool) {
//        //let userId = "11de14fa-6133-4c76-8e20-1653ba227ab6"
//
//    }
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "fromWelcomeToCountries" {
//            if favouriteTeam != nil {
//                (segue.destinationViewController as? CountriesViewController)?.selectedCountry = Country(rawValue: favouriteTeam!)
//            }
//        }
//    }

}

