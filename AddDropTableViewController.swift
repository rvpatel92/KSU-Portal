//
//  AddDropTableViewController.swift
//  KSU Portal
//
//  Created by Shiv Patel on 10/19/15.
//  Copyright © 2015 Ravi Patel. All rights reserved.
//

import UIKit

class AddDropTableViewController: PFQueryTableViewController, UISearchBarDelegate {
    
    //allows the user to use the search bar to look up classes.
    @IBOutlet weak var testBar: UISearchBar!
    
    
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    
    @IBAction func backToMenuButton(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        // Configure the PFQueryTableView
        self.parseClassName = "Courses"
        self.textKey = "Course"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    //calling the query, and allowing the search bar to search with the query
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: "Courses")
        if testBar.text != "" {
            query.whereKey("Course", containsString: testBar.text)
        }
        
        query.orderByAscending("Course")
        query.limit = 100
        return query
    }
    //functions used for the search bar
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.loadObjects()
    }
    
    
    //creating the tableview with the query and allowing each cell to display the right information
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! PFTableViewCell!
        if cell == nil {
            cell = PFTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        }
        
        // Extract values from the PFObject to display in the table cell
        if let Course = object?["Course"] as? String {
            cell?.textLabel?.text = Course
        }
        if let dayLabel = object?["Days"].stringValue {
            
            let x = dayLabel
            
            if (x == "1") {
                cell?.detailTextLabel?.text = "SU"
                print(cell?.detailTextLabel?.text)
            }
                
            else if (x == "2") {
                cell?.detailTextLabel?.text = "MO"
            }
                
            else if (x == "4") {
                cell?.detailTextLabel?.text = "TU"
            }
                
            else if (x == "8") {
                cell?.detailTextLabel?.text = "WE"
            }
                
            else if (x == "10") {
                cell?.detailTextLabel?.text = "MO,WE"
            }
                
            else if (x == "16") {
                cell?.detailTextLabel?.text = "TH"
            }
                
            else if (x == "20") {
                cell?.detailTextLabel?.text = "TU,TH"
            }
                
            else if (x == "26") {
                cell?.detailTextLabel?.text = "MO,WE,TH"
            }
                
            else if (x == "32") {
                cell?.detailTextLabel?.text = "FR"
            }
                
            else if (x == "34") {
                cell?.detailTextLabel?.text = "MO,FR"
            }
                
            else if (x == "40") {
                cell?.detailTextLabel?.text = "WE,FR"
            }
                
            else if (x == "42") {
                cell?.detailTextLabel?.text = "MO,WE,FR"
            }
                
            else if (x == "54") {
                cell?.detailTextLabel?.text = "MO,TU,TH,FR"
            }
                
            else if (x == "64") {
                cell?.detailTextLabel?.text = "SA"
            }
                
            else if (x == "96") {
                cell?.detailTextLabel?.text = "FR,SA"
            } else {
                cell?.detailTextLabel?.text = "N/A"
            }
            
        }
        
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toCourseDetail"{
            
            let detailScene = segue.destinationViewController as! AddDropDetailViewController
            
            // Pass the selected object to the destination view controller.
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let row = Int(indexPath.row)
                
                detailScene.currentObject = (objects?[row] as? PFObject)
            }
        }else {
            backToMenuButton(self)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
        
        testBar.delegate = self
    }
    
    //functions intended for the search bar
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
        testBar.resignFirstResponder()
        
        self.loadObjects()
    }
    //functions intended for the search bar
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        testBar.resignFirstResponder()
        
        self.loadObjects()
    }
    //functions intended for the search bar
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        testBar.text = ""
        
        testBar.resignFirstResponder()
        
        self.loadObjects()
        
    }
    //function to add a back button to go back to the main menu.
    @IBAction func backToSchedule(sender: AnyObject) {
        self.performSegueWithIdentifier("backToSchedule", sender: self)
    }
}


