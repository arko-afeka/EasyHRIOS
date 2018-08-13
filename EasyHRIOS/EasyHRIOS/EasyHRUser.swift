//
//  EasyHRUser.swift
//  EasyHRIOS
//
//  Created by arkokat on 13/08/2018.
//  Copyright © 2018 arkokat. All rights reserved.
//

import Foundation
import FirebaseAuth

class EasyHRUser {
    let comapnies: [EasyHRCompany]!
    let name: String
    let email: String
    
    init(user: User!, comapnies: [EasyHRCompany]!) {
        self.name = user.displayName!
        self.email = user.email!
        self.comapnies = comapnies!
    }
}
