//
//  Bookmark.swift
//  Midterm
//
//  Created by Justin Chee on 2015-02-25.
//  Copyright (c) 2015 Justin Chee. All rights reserved.
//

import UIKit

var bookmarks = [String]()
var searchForMe: String = ""

class Bookmark: UITableViewController
{
    let cellID = "BookmarkID"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return bookmarks.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as UITableViewCell
        
        var bookmark = bookmarks[indexPath.row]
        
        cell.textLabel?.text = bookmark
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        searchForMe = bookmarks[indexPath.row]
        self.performSegueWithIdentifier("ToSearch", sender: self);
    }
}