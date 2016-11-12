//
//  userVC.swift
//  TwitterLike
//
//  Created by Michael Ballard on 1/7/16.
//  Copyright © 2016 Michael Ballard. All rights reserved.
//

import UIKit

// step 24 create a new UIviewcontroller on storyboard for the user list, then add this controller to implement code, dont forget UIKit and override functions

// step 29 attach the table view as the delegate and data then update the user class to reflect

class userVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var resultsTable: UITableView!
    
    // Step 30 add arrays to pass user infotmation and store data
    
    var resultsNameArray = [String]()
    var resultsUserNameArray = [String]()
    var resultsImageFiles = [PFFile]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //step 27 add the sizing variable and functions for UItable
        
        
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        resultsTable.frame = CGRectMake(0, 0, theWidth, theHeight)
        
        // Do any additional step after loading the view
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    //step 32 create code to fetch user data from Parse API
    
    override func viewDidAppear(animated: Bool) {
        
        resultsNameArray.removeAll(keepCapacity: false)
        resultsUserNameArray.removeAll(keepCapacity: false)
        resultsImageFiles.removeAll(keepCapacity: false)
        
        //queries the parse data
       
        let query = PFQuery(className:"_User")
        
        //places a constraint on not displaying your user name as current user with other users
        
        query.whereKey("username", notEqualTo: (PFUser.currentUser()!.username!))
    
        query.findObjectsInBackgroundWithBlock {
        
            (objects:[PFObject]?,error:NSError?) -> Void in
        
                   if error == nil {
                
                for object in objects! {
                    
                    self.resultsNameArray.append(object.objectForKey("profileName") as! String)
                    self.resultsImageFiles.append(object.objectForKey("photo") as! PFFile)
                    self.resultsUserNameArray.append(object.objectForKey("username") as! String)
                   
                    self.resultsTable.reloadData()
                    
                }
            
            }
        
        }
    
        
    }

    
    
    // step 31 create functions to build out data to table view for all three functions below
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return resultsNameArray.count
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:userCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! userCell
        
        cell.profileLbl.text = self.resultsNameArray[indexPath.row]
        cell.usernameLbl.text = self.resultsUserNameArray[indexPath.row]
        
        // step 34 complete the code for saving followers by registering if a user has previously followed another in the Parse database
        
        let query = PFQuery(className: "follow")
        
        query.whereKey("user", equalTo: PFUser.currentUser()!.username!)
        query.whereKey("userToFollow", equalTo: cell.usernameLbl.text!)
        
        query.countObjectsInBackgroundWithBlock{
            
            (count:Int32, error:NSError?) -> Void in
            
            if error == nil {
                if count == 0 {
                    cell.followBtn.setTitle("follow", forState: UIControlState.Normal)
                } else {
                    cell.followBtn.setTitle("following", forState: UIControlState.Normal)
                    
                }
            }
    
        }
        self.resultsImageFiles[indexPath.row].getDataInBackgroundWithBlock{
            
            (imageData:NSData?, error:NSError?) -> Void in
            
            
            if error == nil {
                
                let image = UIImage(data: imageData!)
        
                
                cell.imgView.clipsToBounds = true
                
                cell.imgView.image = image
                
                
            }
        
        }
        
         
        return cell

    
    
    }

    
}




