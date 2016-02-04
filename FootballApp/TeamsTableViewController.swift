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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableHeaderView?.frame.size.height = 200
        
        let ref = Firebase(url:"\(firebaseUrl)/teams")
        ref.childByAppendingPath(country)
        ref.observeEventType(.ChildAdded, withBlock: { snapshot in
            
            self.teams = snapshot.value as? [[String:String]]
            self.tableView.reloadData()
        })
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
        let userId = "11de14fa-6133-4c76-8e20-1653ba227ab6"
        let ref = Firebase(url:"\(firebaseUrl)/users/\(userId)")
        let nickname = ["favourite_team": sender.selected ? "" : country]
        ref.updateChildValues(nickname)
        sender.selected = !sender.selected
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
