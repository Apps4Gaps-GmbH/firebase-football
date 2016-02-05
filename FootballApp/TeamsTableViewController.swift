//
//  TeamsTableViewController.swift
//  FootballApp
//
//  Created by Pietro Santececca on 04/02/16.
//  Copyright © 2016 Apps4Gaps. All rights reserved.
//

import UIKit
import Firebase

class TeamsTableViewController: UITableViewController {
    
    var teams: [[String:String]]?
    let firebaseUrl = "https://resplendent-torch-3135.firebaseio.com"
    var country: String = "Italy"

    @IBOutlet weak var hearthButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableHeaderView?.frame.size.height = 200
        
        print("\(firebaseUrl)/teams/\(country)")
        let ref = Firebase(url:"\(firebaseUrl)/teams/\(country)")
        ref.observeEventType(.Value, withBlock: { snapshot in
            
            self.teams = snapshot.value as? [[String:String]]
            self.tableView.reloadData()
        })
        
        if let userId = NSUserDefaults.standardUserDefaults().stringForKey("uid") {
            let userRef = Firebase(url: "\(firebaseUrl)/users/\(userId)")
            userRef.observeEventType(.Value, withBlock: { (snapshot) -> Void in
                let favouriteTeam = snapshot.value.objectForKey("favourite_team") as? String
                if favouriteTeam != nil && favouriteTeam == self.country {
                    self.hearthButton.selected = true
                }
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
    
    @IBAction func thisIsMyFavouriteCountry(sender: UIButton) {
        //let userId = "11de14fa-6133-4c76-8e20-1653ba227ab6"
        if let userId = NSUserDefaults.standardUserDefaults().stringForKey("uid") {
            let ref = Firebase(url:"\(firebaseUrl)/users/\(userId)")
            let nickname = ["favourite_team": sender.selected ? "" : country]
            ref.updateChildValues(nickname)
            sender.selected = !sender.selected
        }
    }
    
    @IBAction func goToCountries(sender:UIButton) {
        if ((AppDelegate.sharedDelegate().window?.rootViewController!.isKindOfClass(TeamsTableViewController)) != nil) {
            performSegueWithIdentifier("fromTeamsToCountries", sender: sender)
        }
//        if let viewControllers = navigationController?.viewControllers {
//            for viewController in viewControllers {
//                if viewController.isKindOfClass(TeamsTableViewController) {
//                    print("1")
//                    performSegueWithIdentifier("fromTeamsToCountries", sender: sender)
//                }
//            } 
//        }
        else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    

}
