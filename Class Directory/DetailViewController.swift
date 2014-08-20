//
//  DetailViewController.swift
//  Class Directory
//
//  Created by Nathan Birkholz on 8/19/14.
//  Copyright (c) 2014 Nate Birkholz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var selectedPerson : Person?
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var instructorSwitch: UISwitch!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.firstNameField.text = self.selectedPerson?.firstName
        self.lastNameField.text = self.selectedPerson?.lastName
        

        
    }
    


    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.selectedPerson?.firstName = self.firstNameField.text
        self.selectedPerson?.lastName = self.lastNameField.text

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func instructorSwitchSwitched(sender: UISwitch) {
        if self.instructorSwitch.on {
            println("on")
        } else {
            println("on")
        }
    }
    
    

}
