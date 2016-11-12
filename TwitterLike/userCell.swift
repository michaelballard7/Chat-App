//
//  userCell.swift
//  TwitterLike
//
//  Created by Michael Ballard on 1/8/16.
//  Copyright © 2016 Michael Ballard. All rights reserved.
//

import UIKit


// Step 26? After developing the user interface for user selection, link the UItable and cell. Dont forget to 

// change cocoa to UIkit and add the override functions

class userCell: UITableViewCell {

    @IBOutlet var imgView: UIImageView!
    @IBOutlet var profileLbl: UILabel!
    @IBOutlet var usernameLbl: UILabel!
    @IBOutlet var followBtn: UIButton!
  
    
    
    override func awakeFromNib() {  
        super.awakeFromNib()
        //initialization code
        
        //step 28 set the sizing of the user UI screen elements and picture elements
        
        
        let theWidth = UIScreen.mainScreen().bounds.width
        
        contentView.frame = CGRectMake(0, 0, theWidth, 64)
        
        imgView.center = CGPointMake(32, 32)
        imgView.layer.cornerRadius = imgView.frame.size.width / 2
        profileLbl.frame = CGRectMake(70, 10, theWidth-75, 18)
        followBtn.center = CGPointMake(theWidth-50, 42)
        
        //dont forget to identify all segues between user controllers
        //remember ther has to be a controller for cells within a table
    
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        //configure view for selected state.
    }


 // step 33 create a new class in the Parse data base, add columns for user and user to follow, then add action to the follow button below
    
    
    
    @IBAction func followBtn_click(sender: AnyObject) {
        
        let title = followBtn.titleForState(.Normal)
        if title == "follow" {
            
            let followObj = PFObject(className: "follow")
            followObj["user"] = PFUser.currentUser()!.username
            followObj["userToFollow"] = usernameLbl.text
    
        
            [followObj.saveInBackground()]
            
            followBtn.setTitle("following", forState: UIControlState.Normal)
        }else{
        
            // step 35 enable to delete users we previously followed and erase database
            
            let query = PFQuery(className: "follow")
            
            query.whereKey("user", equalTo: (PFUser.currentUser()!.username)!)
            query.whereKey("userToFollow", equalTo: usernameLbl.text!)
            
            query.findObjectsInBackgroundWithBlock {
                
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    
                    print ("Successfully retrieved data")

                    for object in objects! {
                        
                        object.deleteInBackground()
                        
                    }
            }
            
        }
            
    }
            

            followBtn.setTitle("Follow", forState: UIControlState.Normal)
            
        }

    }
    

