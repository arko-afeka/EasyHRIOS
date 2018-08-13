//
//  OptionCell.swift
//  EasyHRIOS
//
//  Created by arkokat on 14/08/2018.
//  Copyright © 2018 arkokat. All rights reserved.
//

import Foundation
import UIKit

enum MenuOption: String {
    case AddCompany = "Add Company"
    case AddManager = "Add Manager"
    case AddWorker = "Add Worker"
    case SelectShifts = "Select Shifts"
    case AssignShifts = "Assign Shifts"
    case ConfigureShifts = "Configure Shifts"
    case Signout = "Signout"
}

class OptionCell: UITableViewCell {
    @IBOutlet var button: UIButton!
    var currentOption: MenuOption!
    
    var option: MenuOption {
        get {
            return currentOption
        }
        set(newoption) {
            currentOption = newoption
            button.setTitle(newoption.rawValue, for: .normal)
        }
    }
}
