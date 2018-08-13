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
        
        authorize()
    }
    @IBAction func selectedOption(_ sender: UIButton) {
        let cell = sender.superview?.superview as! OptionCell
        print(cell.option)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "option") as! OptionCell
        
        cell.option = options[indexPath.row]
        
        return cell
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        authorize()
    }
    
    func loadUserData(completion: @escaping ([String]) -> Void) {
        activity.startAnimating()
        dbref.child("users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: {
            (snap: DataSnapshot) in
            self.activity.stopAnimating()
            var companies: [String]
            
            if snap.exists() {
                companies = snap.value(forKeyPath: "companies") as! [String]
            } else {
                companies = [String]()
            }
            
            completion(companies)
        }) { (error) in
            self.activity.stopAnimating()
            print(error.localizedDescription)
            let alert = UIAlertController(title: "ERROR", message: "Failed loading user", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
                (action) in
                exit(0)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func loadUserCompanies(companies: [String]) {
        if companies.count == 0 {
            self.options.append(.AddCompany)
            self.tableView.reloadData()
        }
    }
    
    func authorize() {
        if Auth.auth().currentUser != nil {
            loadUserData(completion: loadUserCompanies)
        } else {
            let alert = UIAlertController(title: "ERROR", message: "Failed logging in, please try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            let authUI = FUIAuth.defaultAuthUI()
            self.present(alert, animated: true, completion: {
                self.present((authUI?.authViewController())!, animated: false, completion: nil)
            })
        }
    }
}
