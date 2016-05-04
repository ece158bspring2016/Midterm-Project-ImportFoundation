//
//  CatsTableViewCell.swift
//  Demo
//
//  Created by Jessica on 5/3/16.
//  Copyright © 2016 UCSD. All rights reserved.
//

import UIKit

class CatsTableViewCell: PFTableViewCell {
    
    // make 4 outlets to show data from parse
    @IBOutlet weak var catImageView:UIImageView?
    @IBOutlet weak var catPawIcon:UIImageView?
    @IBOutlet weak var catNameLabel:UILabel?
    @IBOutlet weak var catVotesLabel:UILabel?
    @IBOutlet weak var catCreditLabel:UILabel?
    
    var parseObject:PFObject?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // set up tap interaction with view
        let gesture = UITapGestureRecognizer(target: self, action:#selector(CatsTableViewCell.onDoubleTap(_:)))
        gesture.numberOfTapsRequired = 2
        contentView.addGestureRecognizer(gesture)
        
        // hide paw icon image
        catPawIcon?.hidden = true
    }
    
    // this function is called when tap gesture is recognized
    func onDoubleTap(sender:AnyObject) {
        
        // check if parse object is not null
        if(parseObject != nil) {
            // get votes from parse and case to int
            if var votes:Int? = parseObject!.objectForKey("votes") as? Int {
                
                // increment vote by 1
                votes! += 1
                
                // assign new vote value to parse database
                parseObject!.setObject(votes!, forKey: "votes");
                // save the current object in the background, writing to parse
                // cloud when possible
                parseObject!.saveInBackground();
                
                // reflect the update
                catVotesLabel?.text = "\(votes!) votes";
            }
        }
        
        // make icon visible
        catPawIcon?.hidden = false
        catPawIcon?.alpha = 1.0
        
        UIView.animateWithDuration(1.0, delay: 1.0, options: [], animations: {
            // Within one second, the animation duration, animate
            // the alpha channel from 1 to 0
            self.catPawIcon?.alpha = 0
            
            }, completion: {
                (value:Bool) in
                // hide image when animation finished
                self.catPawIcon?.hidden = true
        })
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
