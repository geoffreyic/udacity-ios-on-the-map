//
//  EnterLocationViewController.swift
//  OnTheMap
//
//  Created by Geoffrey_Ching on 7/8/16.
//  Copyright © 2016 Geoffrey Ching. All rights reserved.
//

import UIKit

class EnterLocationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var enterLocationTextField: ModalTextField!
    @IBOutlet weak var findOnMapSegueButton: UIButton!
    
    @IBOutlet weak var findOnMapBottomConstaint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // register keyboard listener
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(FindLocationViewController.keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(FindLocationViewController.keyboardWillDisappear(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func cancelModal(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == "FindOnMap"){
            let vc = segue.destinationViewController as! FindLocationViewController
            
            vc.locationEntered = enterLocationTextField.text!
        }
    }
    
    @IBAction func textFieldEdited(sender: AnyObject) {
        let textF = sender as! UITextField
        
        if(!textF.text!.isEmpty){
            findOnMapSegueButton.enabled = true
        }else{
            findOnMapSegueButton.enabled = false
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    // keyboard detection
    
    func keyboardWillAppear(notification: NSNotification){
        
        
        let kHeight = getKeyboardHeight(notification)
        
        findOnMapBottomConstaint.constant = kHeight + 20
        
        
    }
    
    
    func keyboardWillDisappear(notification: NSNotification){
        print("keyboard will disappear")
        
        findOnMapBottomConstaint.constant = 40
        
    }
    
    // from Building MemeMe 1.0 Classroom
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
}
