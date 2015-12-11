//
//  FacultyTableViewController.swift
//  KSU Portal
//
//  Copyright © 2015 Ravi Patel. All rights reserved.
//

import UIKit

class FacultyTableViewController: PFQueryTableViewController, UISearchBarDelegate{

    @IBOutlet weak var testSearchButton: UISearchBar!

    
    
    // Initialise the PFQueryTable tableview
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
        
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        // Configure the PFQueryTableView
        self.parseClassName = "faculty"
        self.textKey = "Name"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false

    }
    
    //Query the table to get results, and allows us to search the query
    override func queryForTable() -> PFQuery {
        
        let query = PFQuery(className: "faculty")
        if testSearchButton.text != "" {
            query.whereKey("Name", containsString: testSearchButton.text)
        }
        
        query.orderByAscending("Name")
        query.limit = 1000
        return query
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.loadObjects()
    }
    
    //create a table view with the list of teachers by each cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! PFTableViewCell!
        if cell == nil {
            cell = PFTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        }
        
        // Extract values from the PFObject to display in the table cell
        if let Name = object?["Name"] as? String {
            cell?.textLabel?.text = Name
        }
        if let Department = object?["Department"] as? String {
            cell?.detailTextLabel?.text = Department
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the new view controller using [segue destinationViewController].
        if segue.identifier == "test" {
            let detailScene = segue.destinationViewController as! FacultyDetailViewController
        
            // Pass the selected object to the destination view controller.
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let row = Int(indexPath.row)
                detailScene.currentObject = (objects?[row] as? PFObject)
            }
        } else {
            backToMenuButton(self)
        }
    }
    
    
    @IBAction func backToMenuButton(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
        
        testSearchButton.delegate = self
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
        testSearchButton.resignFirstResponder()
        
        self.loadObjects()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        testSearchButton.resignFirstResponder()
        
        self.loadObjects()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        testSearchButton.text = ""
        
        testSearchButton.resignFirstResponder()
        
        self.loadObjects()
    }
  
}
