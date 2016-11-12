//
//  mainCell.swift
//  TwitterLike
//
//  Created by Michael Ballard on 1/7/16.
//  Copyright © 2016 Michael Ballard. All rights reserved.
//

import UIKit

class mainCell: UITableViewCell {

    
    // step 16 post creating a new viewcontroller for the main cell link all cell elements to the view controller

    @IBOutlet var imgView: UIImageView!
    @IBOutlet var profileLbl: UILabel!
    @IBOutlet var messageTxt: UITextView!
    
    @IBOutlet var postImg: UIImageView!
    
    //step 18: create the overide functions for awakeFromNib and setSelected(find out what these are)
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //step 19 set the size of UI screens on the table for photos and other elements
        
        
        let theWidth = UIScreen.mainScreen().bounds.width
        
        contentView.frame = CGRectMake(0, 0, theWidth, 90)
        
        imgView.center = CGPointMake(35, 35)
        imgView.layer.cornerRadius = imgView.frame.size.width/2
        imgView.clipsToBounds = true 
        profileLbl.frame = CGRectMake(70, 5, theWidth-75, 20)
        messageTxt.frame = CGRectMake(70, 22, theWidth-75, 60)
        
        
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated
        )
        
        // configures the view for the selected state
    }
    
    
    

}



