//
//  LoginScreen.swift
//  EasyHRIOS
//
//  Created by arkokat on 12/08/2018.
//  Copyright © 2018 arkokat. All rights reserved.
//

import Foundation
import FirebaseUI
import UIKit

class LoginViewController: UITableViewController, FUIAuthDelegate {
    @IBOutlet var activity: UIActivityIndicatorView!
    
    var shouldUpdate = false
    var dbref: DatabaseReference!
    var options = [MenuOption]()
    var currentUser: EasyHRUser!
    
    override func viewDidLoad() {
        dbref = Database.database().reference()
        
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        authUI?.providers = [
            FUIGoogleAuth()
        ]
        
        authorize(popAlert: false)
    }
    
    @IBAction func selectedOption(_ sender: UIButton) {
        shouldUpdate = true
        let cell = sender.superview?.superview as! OptionCell
        switch cell.option {
        case .AddCompany:
            let addCompanyView = self.storyboard?.instantiateViewController(withIdentifier: "AddCompany")
            self.navigationController?.pushViewController(addCompanyView!, animated: true)
        case .Signout:
            do {
                shouldUpdate = false
                try Auth.auth().signOut()
                exit(0)
            } catch {
                
            }
        default:
            let _ = 0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if shouldUpdate {
            updatedData()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "option") as! OptionCell
        
        cell.option = options[indexPath.row]
        
        return cell
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        authorize(popAlert: true)
    }
    
    func loadUserData() {
        dbref.child(DBKeys.users.rawValue).child(EasyHRUser.current().id)
            .observeSingleEvent(of: .value, with: {
            (snap: DataSnapshot) in
            var companies = [String]()
            
            if snap.exists() {
                let userData = snap.value as! NSDictionary
                let userCompanies = userData[DBKeys.companies.rawValue] as! NSDictionary
                for (key, value) in userCompanies {
                    companies.append((key as! NSString) as String)
                }
            }
            
            self.loadUserCompanies(companies: companies)
        })
    }
    
    func updatedData() {
        self.options = [MenuOption]()
        
        self.options.append(.AddCompany)
        if (EasyHRUser.current().companies.count > 0) {
            self.options.append(.SelectCompany)
        }
        
        self.options.append(.Signout)
        self.tableView.reloadData()
    }
    
    func loadUserCompanies(companies: [String]) {
        if companies.count == 0 {
            updatedData()
        } else {
            var hits = 0
            for company in companies {
                dbref.child(DBKeys.companies.rawValue)
                    .child(company)
                    .observeSingleEvent(of: .value) {
                        (data: DataSnapshot) in
                        hits += 1
                        if !data.exists() {
                            if (hits == companies.count) {
                                self.updatedData()
                            }
                            
                            return
                        }
                        
                        let companyDict = data.value as! NSDictionary
                        var managers = [String]()
                        var workers = [String]()
                        
                        for (key, value) in (companyDict["managers"] as! NSDictionary) {
                            managers.append(key as! String)
                        }
                        
                        for (key, value) in (companyDict["workers"] as! NSDictionary) {
                            workers.append(key as! String)
                        }
                        
                        if workers.contains(EasyHRUser.current().id) {
                            let companyFormatted =
                                EasyHRCompany(uid: company, name: companyDict["name"] as! String, managers: managers, workers: workers)
                            EasyHRUser.current().addCompany(company: companyFormatted)
                        }
                        
                        if (hits == companies.count) {
                            self.updatedData()
                        }
                }
            }
        }
    }
    
    func authorize(popAlert: Bool) {
        if Auth.auth().currentUser != nil {
            loadUserData()
        } else {
            DispatchQueue.main.async {
                if (popAlert) {
                    let alert = UIAlertController(title: "ERROR", message: "Failed logging in, please try again", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    let authUI = FUIAuth.defaultAuthUI()
                    self.present(alert, animated: true, completion: {
                        self.present((authUI?.authViewController())!, animated: false, completion: nil)
                    })
                } else {
                    let authUI = FUIAuth.defaultAuthUI()
                    self.present((authUI?.authViewController())!, animated: false, completion: nil)
                }
            }
        }
    }
}
