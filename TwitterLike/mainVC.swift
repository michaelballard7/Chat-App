//
//  mainVC.swift
//  TwitterLike
//
//  Created by Michael Ballard on 1/6/16.
//  Copyright © 2016 Michael Ballard. All rights reserved.
//

import UIKit

    // Step 14: create this new UIController for the main View

class mainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // step 16 post create new view controloller we must link the new table view to the view controller
    
    @IBOutlet var resultsTable: UITableView!
    
    // step 42 after adding UITableView classes above add new arrays,
    
    var followArray = [String]()
    var resultsNameArray = [String]()
    var resultsImageFiles = [PFFile]()
    var resultsPostArray = [String]()
    
    // ~step 50: create new arrays to fetch posted images
    
    var resultsHasImageArray = [String]()
    var resultsPostImageFiles = [PFFile?]()
    
    // ~step 55 create a variable for the refresher
    
    var refresher:UIRefreshControl!
    

    
    //--> Dont forget to add the viewDidLoad function when adding a new sheet. May be smart to save this as a code snippet
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // step: 17 set the size of the total result table
        
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        resultsTable.frame = CGRectMake(0, 0, theWidth, theHeight)
        
        
        //step 21 create the buttons for the navigation bar (exchange tweet for message in all names)
        
        
        
        let messageBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action: Selector("messageBtn_click"))
        
        let searchBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: Selector("searchBtn_click"))
        
        let buttonArray = NSArray(objects: messageBtn, searchBtn)
        self.navigationItem.rightBarButtonItems = buttonArray as? [UIBarButtonItem]
        
        
        //step 56, add the function for the refresher
        
        refresher = UIRefreshControl()
        refresher.tintColor = UIColor.blackColor()
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.resultsTable.addSubview(refresher)
        

        }
    
    
        // step 57, create the refresh function
    
        func refresh() {
        
            print("refresh table")
        
            self.refresher.endRefreshing()
        
        }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dipose of any resources that can be reduced
        }

    //step 20 create a viewWillAppear function
    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationItem.hidesBackButton = true
        
        }
    
    
    // step 44 view did appear func and fetch data for posts
    
    
    override func viewDidAppear(animated: Bool) {
        
        followArray.removeAll(keepCapacity: false)
        resultsNameArray.removeAll(keepCapacity: false)
        resultsImageFiles.removeAll(keepCapacity: false)
        resultsPostArray.removeAll(keepCapacity: false)
        
        // remove results to fetch images with posts
        
        resultsHasImageArray.removeAll(keepCapacity: false)
        resultsPostImageFiles.removeAll(keepCapacity: false)
        
        
        //we have to fill our follow array with users we follow
        
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("user", equalTo:PFUser.currentUser()!.username!)
        
        let objects = try!followQuery.findObjects()
            
            //(objects: [PFObject]?, error: NSError?) -> Void in
            
            //if error == nil {
                
                print ("Successfully retrieved data")
                
                for object in objects {
                   
                    self.followArray.append(object.objectForKey("userToFollow") as! String)
                    
                //}
                
           // }
            
        }
    
        
        
        // create query for posts to be fetched and attach information to correct arrays
      
        let query = PFQuery(className:"posts")
        
        query.whereKey("userName",containedIn: followArray)
        query.addAscendingOrder("createdAt")
        
        query.findObjectsInBackgroundWithBlock {
            
          (objects:[PFObject]?, error:NSError?) -> Void in
    
          if error == nil {
                
                for object in objects! {
                    
                  
                    self.resultsNameArray.append(object.objectForKey("profileName") as! String)
                    self.resultsImageFiles.append(object.objectForKey("photo") as! PFFile)
                    self.resultsPostArray.append(object.objectForKey("post") as! String)
                    
                    // append the image arrays for imageposts this fetches the image from the database 
                    self.resultsHasImageArray.append(object.objectForKey("hasImage") as! String)
                    
                    self.resultsPostImageFiles.append(object.objectForKey("postImage") as? PFFile)
                    
                    self.resultsTable.reloadData()
                    
                    
                }
            }
        
        
        }
      
    
    
    
    }



    // step 43 create table functions..
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return resultsNameArray.count
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        // ~step 52: add to function to expand table view if image is present
        
        if resultsHasImageArray [indexPath.row] == "yes" {
        
            return self.view.frame.size.width - 10
        
        
        } else {
        
        
        return 90
        
        }
        
    
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:mainCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! mainCell
        
        // ~step 53, hide the uImage if no post with Image is present
        
            cell.postImg.hidden = true
        
        
        //install post adding fetched post to arrays to display on the tableView
        
        cell.profileLbl.text = self.resultsNameArray[indexPath.row]
        cell.messageTxt.text = self.resultsPostArray[indexPath.row]
        
        resultsImageFiles[indexPath.row].getDataInBackgroundWithBlock {
            
            (imageData:NSData?, error:NSError?) -> Void in
            
            if error == nil {
                
                let image = UIImage(data:imageData!)
                cell.imgView.image = image
            }
            
        
        
        }
        
        // ~step54, add code to display UImage if posted image is present
        
        if resultsHasImageArray[indexPath.row] == "yes" {
            
            let theWidth = view.frame.size.width
            cell.postImg.frame = CGRectMake(70, 70, theWidth-85, theWidth-85)
            cell.postImg.hidden = false
            
            resultsPostImageFiles[indexPath.row]?.getDataInBackgroundWithBlock(
                {(imageData:NSData?, error:NSError?) -> Void in
            
            
                    if error == nil {
                        
                        let image = UIImage(data: imageData!)
                        cell.postImg.image = image
        
                    }
                    
                    
            })
        }
        
        return cell
        
    
        
    }
    
    
    //step 22 create functions to execute navigation buttons when clicked 
    
    
    func messageBtn_click() {
        
        print("message button pressed")
        
        // step 35 intiate the message button to go to message VC
        
        self.performSegueWithIdentifier("gotoMessageVCFromMainVC", sender: self)
    
        }
    
    func searchBtn_click() {
        
        print("search button pressed")
   
        
        //step 25 perform segue from mainVC to UserVC, add tableview and cell when finished
        
        self.performSegueWithIdentifier("gotoUsersVCFromMainVC", sender: self)
        
        }
 
    
    //Step 23 after creating functions for search and message create button on UI for stop and functo logout
    
    
    @IBAction func logoutBtn(sender: AnyObject) {
    
        PFUser.logOut()
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    
        }
    
    


}






