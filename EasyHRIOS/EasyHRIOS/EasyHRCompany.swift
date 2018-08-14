//
//  EasyHRCompany.swift
//  EasyHRIOS
//
//  Created by arkokat on 13/08/2018.
//  Copyright © 2018 arkokat. All rights reserved.
//

import Foundation

class EasyHRCompany {
    let name: String!
    let uid: String!
    var managers = [String]()
    var workers = [String]()
    var shifts = [EasyHRShift]()
    
    init(uid: String!, name: String!, managers: [String]!, workers: [String]!) {
        self.uid = uid
        self.name = name
        self.managers = managers
        self.workers = workers
    }
}
