//
//  User.swift
//  TimeTracker
//
//  Created by Michał Szyszka on 19.09.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import Foundation
class User : CustomStringConvertible {
    
    //MARK: Fields
    
    var userId: String
    var email: String
    
    var name: String! = ""
    var surname: String! = ""
    
    //MARK: Inits
    init(id: String, email: String) {
        self.userId = id
        self.email = email
    }
    
    //MARK: Properties
    
    var description: String {
        return "\(email), \(userId)"
    }
}
