//
//  TeamsTableViewController.swift
//  FootballApp
//
//  Created by Pietro Santececca on 04/02/16.
//  Copyright © 2016 Apps4Gaps. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class TeamsTableViewController: UITableViewController, CountriesDelegate {
    
    var teams: [[String:String]]?
    let firebaseUrl = "https://resplendent-torch-3135.firebaseio.com"
    var country: String = "Italy"

    @IBOutlet weak var hearthButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableHeaderView?.frame.size.height = 200
        updateTeamsCountry()
    }
    
    func updateTeamsCountry() {
        let ref = Firebase(url:"\(firebaseUrl)/teams/\(country)")
        ref.observeEventType(.Value, withBlock: { snapshot in
            
            self.teams = snapshot.value as? [[String:String]]
            self.tableView.reloadData()
            ref.removeAllObservers()
        })
        
        
        if let userId = NSUserDefaults.standardUserDefaults().stringForKey("uid") {
            let userRef = Firebase(url: "\(firebaseUrl)/users/\(userId)")
            userRef.observeEventType(.Value, withBlock: { (snapshot) -> Void in
                let favouriteTeam = snapshot.value.objectForKey("favourite_team") as? String
                if favouriteTeam != nil && favouriteTeam == self.country {
                    self.hearthButton.selected = true
                }
                else {
                    self.hearthButton.selected = false
                }
                userRef.removeAllObservers()
            })
            
        }
    }

    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams != nil ? teams!.count : 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! TeamTableViewCell
        if teams != nil {
            cell.setTeamValue(teams![indexPath.row]["name"], city: teams![indexPath.row]["city"])
        }
        return cell
    }
    
    func updateFavouriteCountry(favoutireCountry: Country) {
        country = favoutireCountry.rawValue
        updateTeamsCountry()
    }
    
    @IBAction func thisIsMyFavouriteCountry(sender: UIButton) {
        //let userId = "11de14fa-6133-4c76-8e20-1653ba227ab6"
        if let userId = NSUserDefaults.standardUserDefaults().stringForKey("uid") {
            let ref = Firebase(url:"\(firebaseUrl)/users/\(userId)")
            let nickname = ["favourite_team": sender.selected ? "" : country]
            ref.updateChildValues(nickname)
            sender.selected = !sender.selected
            ref.removeAllObservers()
        }
    }
    
    @IBAction func goToCountries(sender:UIButton) {
        if ((AppDelegate.sharedDelegate().window?.rootViewController!.isKindOfClass(TeamsTableViewController)) == true) {
            performSegueWithIdentifier("fromTeamsToCountries", sender: sender)
        }
        else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "fromTeamsToCountries" {
            if let countriesViewController = segue.destinationViewController as? CountriesViewController {
                countriesViewController.countriesDelegate = self
             }
        }
    }

    

    @IBAction func logoutButtonTapped(sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (alertAction) -> Void in }
        let logoutAction = UIAlertAction(title: "Log out", style: .Destructive) { (alertAction) -> Void in
            FBSDKLoginManager().logOut()
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "loggedIn")
            NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
            AppDelegate.sharedDelegate().setInitialAsRootViewController()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(logoutAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}
