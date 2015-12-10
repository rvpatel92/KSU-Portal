//
//  AddDropDetailViewController.swift
//  KSU Portal
//
//  Created by Shiv Patel on 10/19/15.
//  Copyright © 2015 Ravi Patel. All rights reserved.
//

import UIKit
import Parse

class AddDropDetailViewController: UIViewController {
    
    //obtain the current object that is being requested from parse
    
    var currentObject : PFObject?
    
    // defines the label to each label on the storyboard
    
    @IBOutlet weak var CRN: UILabel!
    @IBOutlet weak var CourseName: UILabel!
    @IBOutlet weak var Days: UILabel!
    @IBOutlet weak var Professor: UILabel!
    @IBOutlet weak var Credits: UILabel!
    @IBOutlet weak var Seats: UILabel!
    @IBOutlet weak var TimeTicket: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // if variable object is equal to existing object, obtain each field and display it
        // in the label fields.
        if let object = currentObject {
            
            if (object["CRN"] != nil)
            {
                CRN.text = object["CRN"] as? String
            } else {
                CRN.text = "N/A"
            }
            
            if (object["Course"] != nil)
            {
                CourseName.text = object["Course"] as? String
            } else {
                CourseName.text = "N/A"
            }
            
            if (object["Days"] != nil)
            {
                let myString = object["Days"]
                let x = String(myString)
                
                if (x == "1") {
                    Days.text = "SU"
                    print(Days.text)
                }
                
                else if (x == "2") {
                    Days.text = "MO"
                }
                
                else if (x == "4") {
                    Days.text = "TU"
                }
                
                else if (x == "8") {
                    Days.text = "WE"
                }
                
                else if (x == "10") {
                    Days.text = "MO,WE"
                }
                
                else if (x == "16") {
                    Days.text = "TH"
                }
                
                else if (x == "20") {
                    Days.text = "TU,TH"
                }
                
                else if (x == "26") {
                    Days.text = "MO,WE,TH"
                }
                
                else if (x == "32") {
                    Days.text = "FR"
                }
                
                else if (x == "34") {
                    Days.text = "MO,FR"
                }
                
                else if (x == "40") {
                    Days.text = "WE,FR"
                }
                
                else if (x == "42") {
                    Days.text = "MO,WE,FR"
                }
                
                else if (x == "54") {
                    Days.text = "MO,TU,TH,FR"
                }
                
                else if (x == "64") {
                    Days.text = "SA"
                }
                
                else if (x == "96") {
                    Days.text = "FR,SA"
                } else {
                    Days.text = "N/A"
                }
                
            }
            //query through a pointer to get the name of the faculty member.
            if (object["Professor"] != nil)
            {
                let name = object["Professor"] as? String
                let facultyID = PFQuery(className: "faculty")
                facultyID.getObjectInBackgroundWithId(name!) { (object: PFObject?, error: NSError?) -> Void in
                    if error == nil && object != nil {
                        self.Professor.text = object!["Name"] as? String
                    } else {
                        print(error)
                    }
                }
            } else {
                Professor.text = "N/A"
            }
            
            if (object["Credits"] != nil)
            {
                let myString = object["Credits"]
                let x = String(myString)
                Credits.text = x
            } else {
                Credits.text = "N/A"
            }
            
            if (object["Seats"] != nil)
            {
                let myString = object["Seats"]
                let x = String(myString)
                Seats.text = x
            } else {
                Seats.text = "N/A"
            }
            
            if (object["Time"] != nil)
            {
                TimeTicket.text = object["Time"] as? String
            } else {
                TimeTicket.text = "N/A"
            }

        }
    }
    
    @IBAction func AddButton(sender: AnyObject) {
        
        
        // provide a list of constraints that when a user adds the class,
        // it must run through each check, then lets the user adds the class
        if let currentObj = currentObject {
            let StudentCRN = PFObject(className:"User_course")
            let currentUser = PFUser.currentUser()
            let courseID = currentObj
            let checkCRN = checkDuplicateCRN(courseID)
            let hold = checkHolds()
            checkCourseName(courseID)
            print(currentObj.description)
            print(updateSeats(currentObj))
            
            //checks if the univeristy puts a hold on the user
            if (hold == false) {
                //checks if the CRN is not the same as another CRN
                if (checkCRN == false) {
                    //checks if the total number of classes does not pass 16
                    if(getTotalHours() < 16) {
                        //checks if there are no duplicate course names
                        if (checkCourseName(courseID) == false) {
                            //checks if the user does not add a class where there are zero seats.
                            if (updateSeats(courseID) == false) {
                                StudentCRN["user_id"] = currentUser
                                StudentCRN["course_id"] = currentObj
                                let answer = Int((currentObj["Seats"] as? Int)!) - 1
                                currentObj["Seats"] = answer
                                StudentCRN.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                                    if (success) {
                                        let alertView = UIAlertController(title: "Successful", message: "Course Successfully Added To Schedule", preferredStyle: .Alert)
                                        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                                        self.presentViewController(alertView, animated: true, completion: nil)
                                    } else {
                                        let alertView = UIAlertController(title: "Unsuccessful Course Add", message: "Course could not be Successfully Added", preferredStyle: .Alert)
                                        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                                        self.presentViewController(alertView, animated: true, completion: nil)
                                    }
                                })
                            } else {
                                let alertView = UIAlertController(title: "No more Seats Available", message: "There are no more seats at this time.", preferredStyle: .Alert)
                                alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                                self.presentViewController(alertView, animated: true, completion: nil)
                            }
                        } else {
                            let alertView = UIAlertController(title: "Same Course Already Added", message: "Course Name matches up with Selected Course", preferredStyle: .Alert)
                            alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                            self.presentViewController(alertView, animated: true, completion: nil)
                        }
                    } else {
                        let alertView = UIAlertController(title: "Too many Credits", message: "Allowed only 18 Credit Hours", preferredStyle: .Alert)
                        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                        self.presentViewController(alertView, animated: true, completion: nil)
                    }
                } else {
                    let alertView = UIAlertController(title: "Duplicate CRN", message: "Course is already added", preferredStyle: .Alert)
                    alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    self.presentViewController(alertView, animated: true, completion: nil)
                }
            } else {
            let alertView = UIAlertController(title: "Hold on Account", message: "Please Contact Registrar", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
            }
        }
        
    }
    
    //checks if there are enough seats for the user to add
    func updateSeats(courseID: PFObject) -> Bool
    {
        var myBool: Bool = false
        
        let cID = courseID
        
        let query = PFQuery(className: "User_course")
        
        query.whereKey("user_id", equalTo: PFUser.currentUser()!)
        
        query.selectKeys(["course_id"])
        
        var courseName: NSArray = []
        
        try! courseName = query.findObjects() as [PFObject]
        
        for var i = 0; i < courseName.count; i++ {
            
            let query2 = PFQuery(className: "Courses")
            
            query2.whereKey("objectId", equalTo: (courseName.objectAtIndex(i).objectForKey("course_id")?.objectId)! as String)
            
            var courseName2: NSArray = []
            
            try! courseName2 = query2.findObjects()
            
            let compar2 = Int((courseName2.objectAtIndex(0).objectForKey("Seats") as! Int))
            print(compar2)

            if (compar2 > 0) {
                myBool = true
            } else {
                print("")
            }
        }
        return myBool
    }
    
    //checks if there are no duplicate course names with the classes added so far.
    func checkCourseName(courseID: PFObject) -> Bool {
        
        var myBool: Bool = false
        
        let cID = courseID
        
        let query = PFQuery(className: "User_course")
        
        query.whereKey("user_id", equalTo: PFUser.currentUser()!)
        
        query.selectKeys(["course_id"])
        
        var courseName: NSArray = []
        
        try! courseName = query.findObjects() as [PFObject]
        
        for var i = 0; i < courseName.count; i++ {
            
            let query2 = PFQuery(className: "Courses")
            
            query2.whereKey("objectId", equalTo: (courseName.objectAtIndex(i).objectForKey("course_id")?.objectId)! as String)
            
            var courseName2: NSArray = []
            
            try! courseName2 = query2.findObjects()
            
            let compar1 = cID["Course"] as! String
            
            let compar2 = String((courseName2.objectAtIndex(0).objectForKey("Course") as! String))
            
            if (compar1 == compar2) {
                myBool = true
            } else {
                print("")
            }
        }
        
        return myBool
    }

    //returns a boolean to see whether the course is a duplicate CRN of the classes already added.
    func checkDuplicateCRN(courseID: PFObject) -> Bool {
        
        let query = PFQuery(className: "User_course")
        
        let cID = courseID
    
        var myBool: Bool = false
        
        query.whereKey("user_id", equalTo: PFUser.currentUser()!)
        query.whereKey("course_id", equalTo: cID)
        
        var course: NSArray = []

        try? course = query.findObjects()
        
        if (course.count > 0)
        {
            myBool = true
        } else {
            print("")
        }
        
        return myBool
    }

    //returns the boolean for whether the user has a hold on the account or not
    func checkHolds() -> Bool {
        
        let currentUser = PFUser.currentUser()
        
        var myBool: Bool
        
        myBool = currentUser?.objectForKey("Hold") as! Bool
        
        return myBool
    }
    
    
    //obtain the total amount of hours the user has signed up for classes.
    func getTotalHours() -> Int {
        
        let query = PFQuery(className: "User_course")
        
        query.whereKey("user_id", equalTo: PFUser.currentUser()!)
        
        query.selectKeys(["course_id"])
        
        var total : Int = 0
        
        var hours: NSArray = []
        
        try! hours = query.findObjects() as [PFObject]
        
        for var i = 0; i < hours.count; i++ {
            
            let query2 = PFQuery(className: "Courses")
            
            query2.whereKey("objectId", equalTo: (hours.objectAtIndex(i).objectForKey("course_id")?.objectId)! as String)
            
            var hours2: NSArray = []
            
            try! hours2 = query2.findObjects()
            
            let answer: Int = Int(hours2.objectAtIndex(0).objectForKey("Credits") as! Int)
            
            total += answer
            print(total)
            
        }
        return total
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}