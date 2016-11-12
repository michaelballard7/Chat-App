//
//  SignupVC.swift
//  TwitterLike
//
//  Created by Michael Ballard on 1/4/16.
//  Copyright © 2016 Michael Ballard. All rights reserved.
//

import UIKit

class SignupVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
 //next step after setting up the mainView controller
// step 3 attach assets to second view comtroller
    
    @IBOutlet var emailTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!
    @IBOutlet var profileTxt: UITextField!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var addBtn: UIButton!
    @IBOutlet var signupBtn: UIButton!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
    // step 4 set the asset sizes
     
        let theWidth = view.frame.size.width

        emailTxt.frame = CGRectMake(100, 180,theWidth-110, 30)
        passwordTxt.frame = CGRectMake(100, 220,theWidth-110, 30)
        addBtn.center = CGPointMake(50, 150)
        imgView.frame = CGRectMake(10, 170, 80, 80)
        profileTxt.frame = CGRectMake(10, 270,theWidth-20, 30)
        signupBtn.center = CGPointMake(theWidth/2, profileTxt.frame.origin.y+70)
        
        // sets the image size and rounds the corners after choosing
        imgView.layer.cornerRadius = imgView.frame.size.width / 2
        imgView.clipsToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //step 7 add the UI functionality of image and signup buttons, attach delegate classess above at cllass Signup VC (UINavi... UIImage)
    
        // install method for Selecting images from iphone (research each method to understamd)
    
    @IBAction func addPhotoBtn(sender: AnyObject) {
    
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = true
        
        self.presentViewController(image, animated: true, completion: nil)

    
    }
    
    //step 8 create the function for the image picker controller
    
    // first code built by myself.. fuck yeah, how to use image chooser from phone library (research each method)
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imgView.contentMode = .ScaleAspectFit
            imgView.image = image
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    //step 9 allow the user to submit photo, email and password to Parse user database or "class"
    
    @IBAction func signUpBtn(sender: AnyObject) {
        
        //create the user variable
        let user = PFUser()
        
        user.username = emailTxt.text
        user.password = passwordTxt.text
        user["profileName"] = profileTxt.text
        
        
        //step 37 paste code allowing us to follow ourselves an post our own content to the main screen
        
        let followObj = PFObject(className: "follow")
        followObj["user"] = PFUser.currentUser()!.username
        followObj["userToFollow"] = PFUser.currentUser()!.username
        followObj.saveInBackground()
        
    
       
        // code below coverts image from imagePicker into readable PNG format for Parse PFFile
        let imageData = UIImagePNGRepresentation(self.imgView.image!)
        let imageFile = PFFile(name: "profilePhoto.png", data: imageData!)
        user["photo"] = imageFile
      
        //user updated swift code here:
        user.signUpInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if error == nil {
                print("User Created!")
                // step 13: create segue from signupVC to mainVC same as step 12
                 self.performSegueWithIdentifier("gotoMainVCFromSignupVC", sender: self)
            }
        
        }
    
    }

}
