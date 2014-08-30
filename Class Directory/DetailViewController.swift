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

            println("DVC Lifecycle viewDidLoad 01")
        super.viewDidLoad()
            println("DVC Lifecycle viewDidLoad 02")
        self.firstNameField.text = self.selectedPerson?.firstName
            println("DVC Lifecycle viewDidLoad 03")
        self.lastNameField.text = self.selectedPerson?.lastName
            println("DVC Lifecycle viewDidLoad 04")
        self.imageView.layer.masksToBounds = true
            println("DVC Lifecycle viewDidLoad 05")
        self.imageView.layer.cornerRadius = 50.0
            println("DVC Lifecycle viewDidLoad 06")
        
        
        if self.selectedPerson?.imageFor.imageAsset == nil {
                println("DVC Lifecycle viewDidLoad 07")
            self.imageView.image = UIImage(named: "stack21")
                println("DVC Lifecycle viewDidLoad 08")

        } else {
        
            println("DVC Lifecycle viewDidLoad 09")
        var loadedImage = self.selectedPerson?.imageFor  // UIImage(named: "stack21")
            println("DVC Lifecycle viewDidLoad 10")
        self.imageView.image = loadedImage
            println("DVC Lifecycle viewDidLoad 11")
        }
            println("DVC Lifecycle viewDidLoad 12")
    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
            println("DVC Lifecycle viewWillAppear 01")

        if self.selectedPerson?.isTeacher == false {
            instructorSwitch.setOn(false, animated: true)
        }

    }


    override func viewWillDisappear(animated: Bool) {
            println("DVC Lifecycle viewWillDisappear 01")
        super.viewWillDisappear(animated)
            println("DVC Lifecycle viewWillDisappear 02")
        
        self.selectedPerson?.firstName = self.firstNameField.text
            println("DVC Lifecycle viewWillDisappear 03")
        self.selectedPerson?.lastName = self.lastNameField.text
            println("DVC Lifecycle viewWillDisappear 04")
        self.selectedPerson?.imageFor = self.imageView.image 
            println("DVC Lifecycle viewWillDisappear 05")
        
        if instructorSwitch.on {
            self.selectedPerson?.isTeacher = true
        } else {
            self.selectedPerson?.isTeacher = false
        }
        
        println(self.selectedPerson?.isTeacher)

    }


    override func didReceiveMemoryWarning() {
            println("DVC Lifecycle didReceiveMemoryWarning 01")
        super.didReceiveMemoryWarning()

    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
            println("DVC Lifecycle textFieldShouldReturn 01")
        textField.resignFirstResponder()
            println("DVC Lifecycle textFieldShouldReturn 02")
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
        self.holdThis()
            println("DVC6")
        var imagePickerController = UIImagePickerController()
            println("DVC7")
        imagePickerController.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum // .camera
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
    
    func holdThis() {
        var alert = UIAlertController(title: "Title", message: "message", preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            (action) in
                println("things here")
            })
        alert.addAction(UIAlertAction(title: "Load from library", style: UIAlertActionStyle.Destructive) {
            (action) in
            println("stuff here")
            //code to choose library here
        })
    }
    
//    func presentCamera()
//    {
//        // Check for the camera device
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
//        {
//            println("YES")
//            var cameraUI = UIImagePickerController()
//            cameraUI.delegate = self
//            cameraUI.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
//            
//            // If true you can pinch and zoom to make a diffrent image
//            cameraUI.allowsEditing = true
//            // Pops the camera UI on screen
//            self.presentViewController(cameraUI, animated: true, completion: nil)
//        }
//        else
//        {
//            var alert = UIAlertView()
//            alert.title = "No Device"
//            alert.message = "Your device does not have the proper camera"
//            alert.addButtonWithTitle("OK")
//            alert.show()
//        }
//        
//        
//    }

}
