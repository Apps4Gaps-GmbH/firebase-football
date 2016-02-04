//
//  TableViewCell.swift
//  FootballApp
//
//  Created by Pietro Santececca on 04/02/16.
//  Copyright © 2016 Apps4Gaps. All rights reserved.
//

import UIKit

class TeamTableViewCell: UITableViewCell {

    
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var cityName: UILabel!
    
    func setTeamValue(team:String?, city: String?) {
        teamName.text = team
        cityName.text = city
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
