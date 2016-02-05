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
    
    var favouriteTeam: String?
    
    override func viewWillAppear(animated: Bool) {
        let userId = "11de14fa-6133-4c76-8e20-1653ba227ab6"
        //let userId = NSUserDefaults.standardUserDefaults().stringForKey("uid")
        let userRef = Firebase(url: "https://resplendent-torch-3135.firebaseio.com/users/\(userId)")
        userRef.observeEventType(.Value, withBlock: { (snapshot) -> Void in
            self.favouriteTeam = snapshot.value.objectForKey("favourite_team") as? String
            if self.favouriteTeam != nil && self.favouriteTeam != "" {
                self.goToCountries()
            }
            print(snapshot.value.objectForKey("favourite_team") as! String)
        })
    }
    
    func goToCountries() {
        self.performSegueWithIdentifier("fromWelcomeToCountries", sender:self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "fromWelcomeToCountries" {
            if favouriteTeam != nil {
                if let nav = segue.destinationViewController as? UINavigationController {
                    if let destinationVC = nav.viewControllers[0] as? CountriesViewController {
                        destinationVC.selectedCountry = Country(rawValue: favouriteTeam!)
                    }
                }
            }
        }
    }

}

