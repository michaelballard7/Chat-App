//
//  messageVC.swift
//  TwitterLike
//
//  Created by Michael Ballard on 1/18/16.
//  Copyright © 2016 Michael Ballard. All rights reserved.
//

import UIKit

// step 35 attached UI items to interface as outlets

class messageVC: UIViewController, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var messageTxt: UITextView!
    @IBOutlet var charsLbl: UILabel!
    @IBOutlet var postBtn: UIButton!
    @IBOutlet var addPhotoBtn: UIButton!
    @IBOutlet var postImage: UIImageView!
    
    var hasImage = false
    
    
// step 37 add viewDidLoad function, didRecieveMemory function, and add measure for outlets
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let theWidth = view.frame.size.width
        
        cancelBtn.center = CGPointMake(36, 50)
        messageTxt.frame = CGRectMake(5, 65, theWidth-10, 78)
        charsLbl.frame = CGRectMake(10, 150, 100, 30)
        postBtn.center = CGPointMake(theWidth-40, 170)
        addPhotoBtn.center = CGPointMake(46, 210)
        postImage.frame = CGRectMake(5, 220, theWidth-10, theWidth-10)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // step 38 add cancel button to modal back to home page
    
    @IBAction func cancelBtn_click(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    
    // step 39 after adding delegate for message txt and UITextviewDelegate add view did change function, add the counting charachters funtion
    
    func textViewDidChange(textView: UITextView) {
        
        let length = messageTxt.text.characters.count
        
        let diff = 90 - length
        
        if diff < 0 {
            
            charsLbl.textColor = UIColor.redColor()
        
        }else{
            
            charsLbl.textColor = UIColor.blackColor()
            
        }
        
        charsLbl.text = "\(diff) chars left"
    }
  
    // step 40 add class and columns to the parse database to send posts
    
    // step 41 add action for the post button
    
    @IBAction func postBtn_click(sender: AnyObject) {
        
        // sub string the message if longer than 90 chrs
        
            let thePost = messageTxt.text
            let length = messageTxt.text.characters.count
        
            if  length > 90 {
            
            thePost == thePost.substringToIndex(thePost.startIndex.advancedBy(90))
            
        }
        
        // create our database record for the posts class
        
            let postOBj = PFObject(className: "posts")
        
            postOBj["userName"] = PFUser.currentUser()!.username
            postOBj["profileName"] = PFUser.currentUser()!.valueForKey("profileName") as! String
            postOBj["photo"] = PFUser.currentUser()!.valueForKey("photo") as! PFFile
            postOBj["post"] = thePost
        
        // ~step 49 add this line to create a record in the database for the posted image, after updating the parse database by adding columns (hasImage, postImage)
        
            if hasImage == true {
                
                postOBj["hasImage"] = "yes"
                
                let imageData = UIImagePNGRepresentation(self.postImage.image!)
                let imageFile = PFFile(name: "postPhoto.png", data:imageData!)
                postOBj["postImage"] = imageFile
                
            }else{
                
                postOBj["hasImage"] = "no"
        }
        
            postOBj.saveInBackground()
            print("posted")
            self.dismissViewControllerAnimated(true, completion: nil)

        
    }
    
    // ~step 48 write the function that executes when we select a photo
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let theInfo:NSDictionary = info as NSDictionary
        let image:UIImage = theInfo.objectForKey(UIImagePickerControllerEditedImage) as! UIImage
        postImage.image = image
        hasImage = true
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    

    
    // step ~47 after adding the photo to message vc add the delegate inheretance to global class and then add code to select image from library
    
    @IBAction func addPhotoBtn_click(sender: AnyObject) {
    
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = true
        
        self.presentViewController(image, animated: true, completion: nil)
    
    }
    
    
}
