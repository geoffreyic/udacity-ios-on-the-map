//
//  EnterLocationViewController.swift
//  OnTheMap
//
//  Created by Geoffrey_Ching on 7/8/16.
//  Copyright © 2016 Geoffrey Ching. All rights reserved.
//

import UIKit

class EnterLocationViewController: UIViewController {

    @IBOutlet weak var enterLocationTextField: ModalTextField!
    @IBOutlet weak var findOnMapSegueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

}
