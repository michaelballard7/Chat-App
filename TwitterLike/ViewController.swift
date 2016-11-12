//
//  ViewController.swift
//  TwitterLike
//
//  Created by Michael Ballard on 1/4/16.
//  Copyright © 2016 Michael Ballard. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
   
    // step 1:  connect each main signUp interface elements to view controller
    
    @IBOutlet var emailTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!
    @IBOutlet var signInBtn: UIButton!
    @IBOutlet var signUpBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // step 2: set the size of elements for sign up view
        
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.width
        
        emailTxt.frame = CGRectMake(40, 200, theWidth-80, 30)
        passwordTxt.frame = CGRectMake(40, 240, theWidth-80, 30)
        signInBtn.center = CGPointMake(theWidth/2, 300)
        signUpBtn.center = CGPointMake(theWidth/2, theHeight-40)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


//step 10 add the user sign button and register signed in user
    
    
    @IBAction func signInBtn(sender: AnyObject) {
        
        let username = self.emailTxt.text
        let password = self.passwordTxt.text
        
        //use PFUSer, a parse variable to call the login function using username and password arguements
        
        PFUser.logInWithUsernameInBackground(username!, password: password!){
        
            (user:PFUser?, error:NSError?) -> Void in
            
            if error == nil {
                
                print("LogIn")
                
                //step 11: post setting up segues to main vc and adding maiVC file add the transition post successful sign in
                self.performSegueWithIdentifier("gotoMainVCFromSigninVC", sender: self)
                
                
            } else {
                
                print ("Wrong password or email")
            
            }
            
        }
        
    
    }
    
    
    
}

