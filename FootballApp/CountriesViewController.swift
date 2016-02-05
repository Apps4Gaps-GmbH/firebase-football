//
//  CountriesViewController.swift
//  FootballApp
//
//  Created by Pietro Santececca on 04/02/16.
//  Copyright © 2016 Apps4Gaps. All rights reserved.
//

import UIKit

enum Country: String {
    case Italy = "Italy"
    case Germany = "Germany"
    case Turkey = "Turkey"
}

class CountriesViewController: UIViewController {

    var selectedCountry: Country?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    @IBOutlet weak var germanyButton: CountryButton! {
        didSet {
            germanyButton.coutryName = Country.Germany
        }
    }
    
    @IBOutlet weak var italyButton: CountryButton! {
        didSet {
            italyButton.coutryName = Country.Italy
        }
    }
    
    @IBOutlet weak var turkeyButton: CountryButton! {
        didSet {
            turkeyButton.coutryName = Country.Turkey
        }
    }
    
    
    // MARK - Navigation
    
    @IBAction func goToCountryTeams(sender:CountryButton) {
        if ((AppDelegate.sharedDelegate().window?.rootViewController!.isKindOfClass(TeamsTableViewController)) != nil) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            selectedCountry = sender.coutryName
            performSegueWithIdentifier("fromCountriesToTeams", sender: sender)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "fromCountriesToTeams" {
            if selectedCountry != nil {
                (segue.destinationViewController as? TeamsTableViewController)?.country = selectedCountry!.rawValue
            }
        }
    }
    
}
