//
//  DetailViewController.swift
//  Class Directory
//
//  Created by Nathan Birkholz on 8/19/14.
//  Copyright (c) 2014 Nate Birkholz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var selectedPerson : Person?
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var instructorSwitch: UISwitch!
    @IBOutlet weak var imageView: UIImageView!
    
//  #MARK: Lifecycle
    
    override func viewDidLoad() {
        

        
        super.viewDidLoad()
            println("DVC1")
        self.firstNameField.text = self.selectedPerson?.firstName
            println("DVC2")
        self.lastNameField.text = self.selectedPerson?.lastName
            println("DVC3")
        if self.selectedPerson?.imageFor.imageAsset == nil {
            println("Thats the problem")
            self.imageView.image = UIImage(named: "stack21")
        } else {
        
        var myImage = self.selectedPerson?.imageFor  // UIImage(named: "stack21")
            println("DVC4")
        self.imageView.image = myImage
            println("DVC5")
        }

    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        

    }


    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.selectedPerson?.firstName = self.firstNameField.text
        self.selectedPerson?.lastName = self.lastNameField.text
        self.selectedPerson?.imageFor = self.imageView.image

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
//    #MARK: Input management
    
    

    
    @IBAction func instructorSwitchSwitched(sender: UISwitch) {
        if instructorSwitch.on {
            println("on")
        } else {
            println("off")
        }
    }
    
    @IBAction func photoButtonPressed(sender: UIButton) {
            println("DVC6")
        var imagePickerController = UIImagePickerController()
            println("DVC7")
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary // .camera
            println("DVC8")
        self.presentViewController(imagePickerController, animated: true, completion: nil /* for some code*/)
            println("DVC9")
        imagePickerController.delegate = self
            println("DVC10")
        imagePickerController.allowsEditing = true
    }

    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        // gets fired when image picker is done
        println("user picked an image")
        
        var editedImage = info[UIImagePickerControllerEditedImage] as UIImage
        self.imageView.image = editedImage
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        // fired when user cancels
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

}
