//
//  CreateCompany.swift
//  EasyHRIOS
//
//  Created by arkokat on 14/08/2018.
//  Copyright © 2018 arkokat. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class CreateCompanyScreen: UIViewController {
    @IBOutlet weak var comanyNameText: UITextField!
    let dbref = Database.database().reference()
    
    @IBAction func save(_ sender: Any) {
        if comanyNameText.text?.count == 0 {
            let alert = UIAlertController(title: "ERROR", message: "Empty name is not allowed", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let uid = UUID().uuidString
            dbref.child(DBKeys.companies.rawValue).child(uid).setValue([
                "workers": [
                    EasyHRUser.current().id: true
                ],
                "managers": [
                    EasyHRUser.current().id: true
                ],
                "name": comanyNameText.text!
            ])
            
            let company = EasyHRCompany(uid: uid, name: comanyNameText.text!, managers: [EasyHRUser.current().id], workers: [EasyHRUser.current().id])
            var user = EasyHRUser.current()
            dbref.child(DBKeys.users.rawValue)
                .child(user.id).child(DBKeys.companies.rawValue)
                .child(uid).setValue(true)
            user.companies.append(company)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
