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
    var customImage = false

    
    
//  #MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("self.customImage.boolValue is \(self.customImage.boolValue)")
        if self.selectedPerson?.imageFor != nil {
            println("found an image")
            self.customImage = true
        }
        println("self.customImage.boolValue is \(self.customImage.boolValue)")
        
        firstNameField.delegate = self
        lastNameField.delegate = self
        
        if selectedPerson? == nil{
            println("NIL PERSON YO")
            self.navigationItem.rightBarButtonItem.enabled = false
        } else {
            self.navigationItem.rightBarButtonItem.enabled = true
        }
        
        if self.selectedPerson?.firstName != nil {
                firstFieldBool = true
        }
        
        if self.selectedPerson?.lastName != nil {
                lastFieldBool = true
            }
        
//        let recognizer = UITapGestureRecognizer(target: self, action: Selector("didTap:"))
//        recognizer.delegate = self
//        view.addGestureRecognizer(recognizer)
        
        self.firstNameField.text = self.selectedPerson?.firstName
        self.lastNameField.text = self.selectedPerson?.lastName
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius = 30.0
        
        if self.selectedPerson?.profileImage?.imageAsset != nil {
            var loadedImage = self.selectedPerson?.profileImage
            self.imageView.image = loadedImage
        } else if self.selectedPerson?.imageFor.imageAsset != nil {
            var loadedImage = self.selectedPerson?.imageFor  // UIImage(named: "stack21")
            self.imageView.image = loadedImage

        } else {
            if self.selectedPerson?.isTeacher == true   {
                self.imageView.image = UIImage(named: "teacher")

            } else if self.selectedPerson?.isTeacher == false {
                self.imageView.image = UIImage(named: "student")
                
            } else {
                self.imageView.image = UIImage(named: "teacher")
                
            }
        }
    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        println("view will appear")

        if self.selectedPerson?.isTeacher == false {
            instructorSwitch.setOn(false, animated: true)
            
        }
        println("github username is \(self.selectedPerson?.gitHubUserName)")
        
        if self.selectedPerson?.gitHubUserName != nil {
            println("has a username")
            self.gitHubUserNameField.text = self.selectedPerson?.gitHubUserName
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
        
            println("the image is \(self.imageView.image.imageAsset)")
            if self.customImage == true {
                self.selectedPerson?.imageFor = self.imageView.image
                println("saved an image")
                
            } else {
                println("it's a default image")
            }
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
                println("won't save")
            } else {
                var newPerson = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: context) as NSManagedObject
                newPerson.setValue(self.firstNameField.text, forKey: "firstName")
                newPerson.setValue(self.lastNameField.text, forKey: "lastName")
                println("the githubfieldtext is \(self.gitHubUserNameField.text)")
                if self.gitHubUserNameField.text == nil {
                    newPerson.setValue(self.gitHubUserNameField.text, forKey: "gitHubUserName")
                }
                
                println("the image is \(self.imageView.image.imageAsset)")
                if self.customImage == true {
                    newPerson.setValue(self.imageView.image, forKey: "imageFor")
                    println("saved an image")
                    
                } else {
                    println("it's a default image")
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
            println("on \(self.selectedPerson?.imageFor.debugDescription)")
            if self.selectedPerson?.imageFor == nil {
                UIView.transitionWithView(self.imageView, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                    self.imageView.image = UIImage(named: "teacher")
                    }, completion: nil)

            }
            
        } else {
            println("off \(self.selectedPerson?.imageFor.debugDescription)")
            if self.selectedPerson?.imageFor == nil {

            UIView.transitionWithView(self.imageView, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                self.imageView.image = UIImage(named: "student")
                }, completion: nil)
            }
        }
    }
    
    @IBAction func photoButtonPressed(sender: UIButton) {
        var imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum // .camera
        self.presentViewController(imagePickerController, animated: true, completion: nil /* for some code*/)
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
    }
    @IBAction func didTap(sender: UITapGestureRecognizer) {
        println("TAPPED BITCHEZ!!!")
        var alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func gitButtonHidden(sender: UIButton) {
        println("quit touching me")
        addUsername()
        
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        // gets fired when image picker is done
        println("user picked an image")
        
        var editedImage = info[UIImagePickerControllerEditedImage] as UIImage
        self.imageView.image = editedImage
        self.customImage = true
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
        alert.addAction(UIAlertAction(title: "Enter a Github Username", style: UIAlertActionStyle.Destructive) {
            (action) in
            println("stuff here")
            //code to choose library here
        })
        alert.addAction(UIAlertAction(title: "More stuff", style: UIAlertActionStyle.Default, handler: nil))
        
        
        
        
        self.presentViewController(alert, animated: true, completion: nil)
        

    }


    func addUsername() {
        var alert = UIAlertController(title: "Username", message: "Enter a Github Username", preferredStyle: UIAlertControllerStyle.Alert)
        var conversionString : String?
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Enter", style: UIAlertActionStyle.Destructive, handler: {
            UIAlertAction in
                let localField = alert.textFields[0] as UITextField
                self.gitHubUserNameField.text = localField.text!
            
                    println("ugh \(localField.text)")
//                self.gitHubUserNameField.text = localField.text!
            
                    println("ugh \(self.selectedPerson?.gitHubUserName)")
            
                UIView.transitionWithView(self.gitHubUserNameField, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                    self.gitHubUserNameField.setNeedsDisplay()
                }, completion: nil)

            }))

        alert.addTextFieldWithConfigurationHandler({ (textFieldAlert: UITextField!) -> Void in
            textFieldAlert.delegate = self
            
            if self.selectedPerson? == nil {
                textFieldAlert.placeholder = "Username"
            } else {
                textFieldAlert.text = self.gitHubUserNameField.text
            }
            
            textFieldAlert.autocapitalizationType = UITextAutocapitalizationType.None
            textFieldAlert.autocorrectionType = UITextAutocorrectionType.No
            
            
            return
        })
        self.presentViewController(alert, animated: true, completion: nil)
        
    
    }
    
    func refreshView () {
        println("You were right, genius!")
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
