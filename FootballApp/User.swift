//
//  User.swift
//  FootballApp
//
//  Created by Tomer Ciucran on 2/4/16.
//  Copyright © 2016 Apps4Gaps. All rights reserved.
//

import Foundation
import Firebase

struct User {
    let email: String!
    let favouriteCountry: String!
    
    // Initialize from Firebase
    init(authData: FAuthData) {
        email = authData.providerData["email"] as! String
        favouriteCountry = nil
    }
    
    // Initialize from arbitrary data
    init(email: String, favouriteCountry: String) {
        self.email = email
        self.favouriteCountry = favouriteCountry
    }
    
    func toAnyObject() -> AnyObject {
        return [
            "email": email,
            "favourite_team": favouriteCountry
        ]
    }
}