//
//  CatsTableViewController.swift
//  Demo
//
//  Created by Jessica on 5/3/16.
//  Copyright © 2016 UCSD. All rights reserved.
//

import UIKit

class CatsTableViewController: PFQueryTableViewController {

    // create constant identifier, only using 1 cell type
    let cellIdentifier:String = "CatCell"
    
    override func viewDidLoad() {
        tableView.registerNib(UINib(nibName: "CatsTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // queries data for the table
    override func queryForTable() -> PFQuery {
        // declare a query that works with instances of cat
        let query:PFQuery = PFQuery(className:self.parseClassName!)
        
        // if the query is empty, query will first look in offline cache for objects
        // if it doesnt find any, download from database
        if(objects?.count == 0)
        {
            query.cachePolicy = PFCachePolicy.CacheThenNetwork
        }
        
        // order queried objects by name column
        query.orderByAscending("name")
        
        return query
    }
    
    // put the data in the table view and return a usable cell view
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        // the instance method takes on parameter (identifier) and cast it to PFTableViewCell
        var cell:CatsTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? CatsTableViewCell
        
        // if there's no cell to dequeue, return nil and create a new cell from
        // the xib, retrieve from collection and give ownership to current class
        // then cast it to CatsTableViewCell
        if(cell == nil) {
            cell = NSBundle.mainBundle().loadNibNamed("CatsTableViewCell", owner: self, options: nil)[0] as? CatsTableViewCell
        }
        
        cell?.parseObject = object
        
        // use optional binding to verify if the optional is non-nil
        // if it contains a value, make that value avaliable as temp constant
        if let pfObject = object {
            // for name
            cell?.catNameLabel?.text = pfObject["name"] as? String
            
            //for vote label, if nil then should appear as 0
            var votes:Int? = pfObject["votes"] as? Int
            if votes == nil {
                votes = 0
            }
            cell?.catVotesLabel?.text = "\(votes!) votes"
            
            // for label
            let credit:String? = pfObject["cc_by"] as? String
            if credit != nil {
                cell?.catCreditLabel?.text = "\(credit!) / CC 2.0"
            }
            
            // for image
            cell?.catImageView?.image = nil
            if let urlString:String? = pfObject["url"] as? String {
                // rework parse url column into an instance of type NSURL
                var url:NSURL? = NSURL(string: urlString!)
                
                if var url:NSURL? = NSURL(string: urlString!) {
                    var error:NSError?
                    var request:NSURLRequest = NSURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 5.0)
                    
                    NSOperationQueue.mainQueue().cancelAllOperations()
                    
                    // start asynchronous NSURLConnection on the main operation
                    // queue, which downloads the image as an NSData object
                    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
                        // when downloading finished, execute
                        // assigns the data from the download to a UIImage
                        (response:NSURLResponse?, imageData:NSData?, error:NSError? ) -> Void in
                        (cell?.catImageView?.image = UIImage(data: imageData!))!
                    })
                }
            }
            
        }
        
        return cell
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // initializer that takes 2 parameters"
    // 1. style of the table view
    // 2. className from Parse we want to use (Cat)
    override init(style: UITableViewStyle, className: String!)
    {
        super.init(style: style, className: className)
        
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        // set max number of object to 25
        self.objectsPerPage = 25

        self.parseClassName = className
        
        // sets the rows to the appropriate height
        self.tableView.rowHeight = 350
        // disallows selection on the cells
        self.tableView.allowsSelection = false
    }
    
    // A required initializer init, which takes one parameter: an instance of NSCoder.
    required init(coder aDecoder:NSCoder)  
    {
        fatalError("NSCoding not supported")  
    }
    
}