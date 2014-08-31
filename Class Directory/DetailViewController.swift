//
//  DetailViewController.swift
//  Class Directory
//
//  Created by Nathan Birkholz on 8/19/14.
//  Copyright (c) 2014 Nate Birkholz. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var selectedPerson : Person?
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var instructorSwitch: UISwitch!
    @IBOutlet weak var imageView: UIImageView!
    
    let context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    
    
//  #MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameField.delegate = self
        lastNameField.delegate = self
        
        if selectedPerson? == nil{
            println("NIL PERSON YO")
        }
        
//        self.navigationItem.backBarButtonItem.title = "Previous"
        
        self.firstNameField.text = self.selectedPerson?.firstName
        self.lastNameField.text = self.selectedPerson?.lastName
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius = 40.0
        
        
        if self.selectedPerson?.imageFor.imageAsset == nil {
            self.imageView.image = UIImage(named: "stack21")

        } else {
        
        var loadedImage = self.selectedPerson?.imageFor  // UIImage(named: "stack21")
        self.imageView.image = loadedImage

        }
    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)

        if self.selectedPerson?.isTeacher == false {
            instructorSwitch.setOn(false, animated: true)
            
        }
    }


    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    @IBAction func cancelUnwind(sender: UIBarButtonItem) {
        dismissViewController()
    }
    
    @IBAction func saveDis(sender: UIBarButtonItem) {
        if (selectedPerson? != nil) {
            editPerson()
            
        } else {
            createPerson()
        }
        
        dismissViewController()
    }
    
    func editPerson() {
            self.selectedPerson?.firstName = self.firstNameField.text
            self.selectedPerson?.lastName = self.lastNameField.text
            self.selectedPerson?.imageFor = self.imageView.image
            
            if instructorSwitch.on {
                self.selectedPerson?.isTeacher = true
            } else {
                self.selectedPerson?.isTeacher = false
            }
            println("is this a teacher? \(self.selectedPerson?.isTeacher)")
        }
    func createPerson() {
        
            if self.firstNameField.text.isEmpty && self.lastNameField.text.isEmpty {
                println("first name empty is \(self.firstNameField.text.isEmpty)")
                println("last name empty is \(self.lastNameField.text.isEmpty)")
                println("M T DOOOOOOOOOOOOO00000000D")
            } else {
                var newPerson = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: context) as NSManagedObject
                newPerson.setValue(self.firstNameField.text, forKey: "firstName")
                newPerson.setValue(self.lastNameField.text, forKey: "lastName")
                
                if self.imageView.image != nil {
                    newPerson.setValue(self.imageView.image, forKey: "imageFor")
                    
                }
                
                if instructorSwitch.on {
                    newPerson.setPrimitiveValue(true, forKey: "isTeacher")
                } else {
                    newPerson.setPrimitiveValue(false, forKey: "isTeacher")
                }
                selectedPerson? = newPerson as Person
            }
            println("is this a teacher? \(self.selectedPerson?.isTeacher)")
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
        self.holdThis()
        var imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum // .camera
        self.presentViewController(imagePickerController, animated: true, completion: nil /* for some code*/)
        imagePickerController.delegate = self
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
    
    func dismissViewController() {
        navigationController.popViewControllerAnimated(true)
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
