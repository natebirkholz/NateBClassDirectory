//
//  DetailViewController.swift
//  Class Directory
//
//  Created by Nathan Birkholz on 8/19/14.
//  Copyright (c) 2014 Nate Birkholz. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class DetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    var selectedPerson : Person?
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var gitHubUserNameField: UITextField!
    @IBOutlet weak var instructorSwitch: UISwitch!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    let context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    
    
    var firstFieldBool : Bool = false
    var lastFieldBool : Bool = false

    
    
//  #MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameField.delegate = self
        lastNameField.delegate = self
        
        if selectedPerson? == nil{
            println("NIL PERSON YO")
            self.navigationItem.rightBarButtonItem.enabled = false
        } else {
            self.navigationItem.rightBarButtonItem.enabled = true
        }
        
//        let recognizer = UITapGestureRecognizer(target: self, action: Selector("didTap:"))
//        recognizer.delegate = self
//        view.addGestureRecognizer(recognizer)
        
//        self.navigationItem.backBarButtonItem.title = "Previous"
        
        self.firstNameField.text = self.selectedPerson?.firstName
        self.lastNameField.text = self.selectedPerson?.lastName
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius = 20.0
        
        if self.selectedPerson?.profileImage?.imageAsset != nil {
            var loadedImage = self.selectedPerson?.profileImage
            self.imageView.image = loadedImage
        } else if self.selectedPerson?.imageFor.imageAsset != nil {
            var loadedImage = self.selectedPerson?.imageFor  // UIImage(named: "stack21")
            self.imageView.image = loadedImage

        } else {
        
            self.imageView.image = UIImage(named: "stack21")


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
            self.selectedPerson?.gitHubUserName = self.gitHubUserNameField.text
        
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
                newPerson.setValue(self.gitHubUserNameField.text, forKey: "gitHubUserName")
                
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
        println(" text is \(textField.text.debugDescription)")
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
    @IBAction func didTap(sender: UITapGestureRecognizer) {
        println("TAPPED BITCHEZ!!!")
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


    
    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {

        
        if textField == firstNameField {
            println("FIRST NAME FIELD IS ACTIVE")
            var yesFirst : NSString = (self.firstNameField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
            println("yesFirst is \(yesFirst)")
            
            if yesFirst.length > 0 {
                firstFieldBool = true
            } else {
                println("why am i here?")
                firstFieldBool = false
            }
            
        } else if textField == lastNameField {
            println("LAST NAME FIELD IS ACTIVE")
            var yesLast : NSString = (self.lastNameField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
            println("yesLast is \(yesLast)")
            
            if yesLast.length > 0 {
                lastFieldBool = true
            } else {
                lastFieldBool = false
            }

        } else {
            println("Neither")
        }
        


//        if (yesFirst.length > 0)  { //|| (yesLast.length > 0)
//            println(self.firstNameField.text)
//            println("IS TEXT")
//            self.navigationItem.rightBarButtonItem.enabled = true
//            println("WAS TEXT")
//
//        } else {
//            println(self.firstNameField.text.debugDescription)
//            println("NOT TEXT")
//            self.navigationItem.rightBarButtonItem.enabled = false
//            println("WASN'T TEXT")

//        }
        if firstFieldBool == false && lastFieldBool == false {
            println("CASE 1 \(firstFieldBool.boolValue), \(lastFieldBool.boolValue)")
            self.navigationItem.rightBarButtonItem.enabled = false
        } else {
            println("CASE 2 \(firstFieldBool.boolValue), \(lastFieldBool.boolValue)")
            self.navigationItem.rightBarButtonItem.enabled = true
        }
        println("returning")
        return true
    }
    
//    func textFieldShouldClear(textField: UITextField!) -> Bool {
//        println("shouldClear")
//        if self.firstNameField.text.isEmpty {
//            println("should clear")
//
//        }
//        return true
//        
//    }
    

    
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
