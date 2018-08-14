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
    private static var loaded = false
    private static var instance: EasyHRUser {
        let user = EasyHRUser(user: Auth.auth().currentUser)
        
        return user
    }
    
    var companies:[EasyHRCompany] = []
    let name: String
    let email: String
    let id: String
    
    private init(user: User!) {
        self.name = user.displayName!
        self.email = user.email!
        self.id = user.uid
    }
    
    func addCompany(company: EasyHRCompany) {
        self.companies.append(company)
    }
    
    static func current() -> EasyHRUser {
       return instance
    }
}
