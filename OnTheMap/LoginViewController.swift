//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Geoffrey_Ching on 7/1/16.
//  Copyright © 2016 Geoffrey Ching. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonAction(sender: AnyObject) {
        activityIndicator.startAnimating()
        UdacityAPI.instance.authorizeAndGetSession(
            usernameTextField.text!,
            password: passwordTextField.text!,
            completionHandler: completeLogin,
            errorHandler: displayError
        )
    }
    
    func completeLogin(){
        UdacityAPI.instance.getUser(
            UdacityAPI.instance.getUserKey(),
            completionHandler: completeFetchingUserData,
            errorHandler: displayError
        )
    }
    
    func completeFetchingUserData(){
        activityIndicator.stopAnimating()
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewControllerWithIdentifier("TabsController") as! UITabBarController
        UIApplication.sharedApplication().keyWindow?.rootViewController = viewController;
    }
    
    func displayError(errorMsg:String){
        activityIndicator.stopAnimating()
        
        let alertController = UIAlertController(title: "Error", message: errorMsg, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            print("OK")
        }
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}
