//
//  LocationBaseViewController.swift
//  OnTheMap
//
//  Created by Geoffrey_Ching on 7/10/16.
//  Copyright © 2016 Geoffrey Ching. All rights reserved.
//

import UIKit

class LocationBaseViewController: UIViewController {
    
    var segueId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func addLocationAction(sender: AnyObject) {
        openAddLocationModal(self, segueId: segueId)
    }
    
    
    func openAddLocationModal(sender: UIViewController, segueId: String){
        
        ParseAPI.instance.getStudentLocation(StudentData.userKey!, completionHandler: {
            if(StudentData.student == nil){
                sender.performSegueWithIdentifier(segueId, sender: sender)
            }else{
                let alertController = UIAlertController(title: "Location Existing", message: "A location already exists, would you like to overwrite?", preferredStyle: UIAlertControllerStyle.Alert)
                
                let overwriteAction = UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                    sender.performSegueWithIdentifier(segueId, sender: sender)
                }
                alertController.addAction(overwriteAction)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (result : UIAlertAction) -> Void in
                    print("Cancel")
                }
                alertController.addAction(cancelAction)
                
                sender.presentViewController(alertController, animated: true, completion: nil)
            }
            }, errorHandler:  { (errorMsg) in
                
                self.displayErrorAlert(sender, errorMsg: errorMsg)
            }
        )
    }
    
    @IBAction func logoutAction(sender: AnyObject) {
        let logoutComplete: ()->Void = {}
        let logoutError: (errorMsg: String)->Void = { errorMsg in
            
        }
        
        UdacityAPI.instance.deleteSession(logoutComplete, errorHandler: logoutError)
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewControllerWithIdentifier("Login")
        UIApplication.sharedApplication().keyWindow?.rootViewController = viewController;
    }
    
    func displayErrorAlert(sender: UIViewController, errorMsg: String){
        let alertController = UIAlertController(title: "Error", message: errorMsg, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            print("OK pressed for error message: " + errorMsg)
        }
        alertController.addAction(okAction)
        sender.presentViewController(alertController, animated: true, completion: nil)
    }
}
