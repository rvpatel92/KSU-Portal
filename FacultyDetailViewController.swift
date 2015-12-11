//
//  FacultyDetailViewController.swift
//  KSU Portal
//
//  Copyright © 2015 Ravi Patel. All rights reserved.
//
//Container to store the view table selected object var currentObject : PFObject?

import UIKit
import MessageUI

class FacultyDetailViewController: UIViewController, MFMailComposeViewControllerDelegate {
    var currentObject : PFObject?

    @IBOutlet weak var Name: UILabel!
    
    @IBOutlet weak var profTitle: UILabel!
    
    @IBOutlet weak var Department: UILabel!
    
    @IBOutlet weak var Email: UIButton!

    
    @IBOutlet weak var OfficeNumber: UILabel!
    
    @IBOutlet weak var Phone: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Unwrap the current object object
        if let object = currentObject {
            if (object["Name"] != nil)
            {
                Name.text = object["Name"] as? String
            } else {
                Name.text = "N/A"
            }
            
            if (object["EmailAddress"] != nil)
            {
                let emailAddress = object["EmailAddress"] as? String
                Email.setTitle(emailAddress, forState: UIControlState.Normal)
            } else {
                Email.setTitle("N/A", forState: UIControlState.Normal)
            }
            
            if (object["Title"] != nil)
            {
                profTitle.text = object["Title"] as? String
            } else {
                profTitle.text = "N/A"
            }
            
            if (object["Department"] != nil) {
                Department.text = object["Department"] as? String
            } else {
                Department.text = "N/A"
            }

            if (object["PhoneNumber"] != nil)
            {
                let phoneNumber = object["PhoneNumber"] as? String
                Phone.setTitle(phoneNumber, forState: UIControlState.Normal)
            } else {
                Phone.setTitle("N/A", forState: UIControlState.Normal)
            }
            
            if (object["OfficeNumber"] != nil) {
                
                OfficeNumber.text = object["OfficeNumber"] as? String
            } else {
                OfficeNumber.text = "N/A"
            }
        }
    }
    
    //if teacher has a valid phone number, allows us to call the teacher if needed.
    @IBAction func callNumber(sender: AnyObject) {
        
        if let object = currentObject {
            let busPhone = object["PhoneNumber"] as? String
           
            let stringArray = busPhone?.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            let newString = stringArray?.joinWithSeparator("")
            
            if  (newString != nil) {
                
                UIApplication.sharedApplication().openURL(NSURL(string: "tel://" + newString!)!)
            }
            else{
                let alert = UIAlertView()
                alert.title = "Sorry!"
                alert.message = "Phone number is not available for this professor!"
                alert.addButtonWithTitle("Ok")
                alert.show()
            }
            
        }

    }
    
    //if the teacher has a valid email, it starts to create an email with the valid KSU email.
    @IBAction func emailProfessor(sender: AnyObject) {
        if let object = currentObject {
            if (object["EmailAddress"] != nil) {
                
                let mailComposeViewController = configuredMailComposeViewController()
                if MFMailComposeViewController.canSendMail() {
                    self.presentViewController(mailComposeViewController, animated: true, completion: nil)
                } else {
                    self.showSendMailErrorAlert()
                }

            } else {
                let alert = UIAlertView()
                alert.title = "Sorry!"
                alert.message = "Email Address is not available for this professor!"
                alert.addButtonWithTitle("Ok")
                alert.show()
            }
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        if let object = currentObject {
            if (object["EmailAddress"] != nil) {
                let emailAddress = object["EmailAddress"] as? String
                mailComposerVC.mailComposeDelegate = self
        
        
                mailComposerVC.setToRecipients([emailAddress!])
                mailComposerVC.setSubject("")
                mailComposerVC.setMessageBody("", isHTML: false)
            }
        }
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
