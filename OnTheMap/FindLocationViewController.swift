//
//  FindLocationViewController.swift
//  OnTheMap
//
//  Created by Geoffrey_Ching on 7/8/16.
//  Copyright © 2016 Geoffrey Ching. All rights reserved.
//

import UIKit
import MapKit

class FindLocationViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mediaUrlTextField: ModalTextField!
    @IBOutlet weak var finderMap: MKMapView!
    
    @IBOutlet weak var submitButtonViewBottomConstraint: NSLayoutConstraint!
    
    var locationEntered:String!
    var locationFound:MKMapItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = locationEntered
        
        let search = MKLocalSearch(request: request)
        
        search.startWithCompletionHandler { (response:MKLocalSearchResponse?, error:NSError?) in
            guard let response = response else{
                dispatch_async(dispatch_get_main_queue()){
                    self.submitRequestErrorHandler("Geocoding failed")
                }
                
                return
            }
            if(error != nil){
                dispatch_async(dispatch_get_main_queue()){
                    self.submitRequestErrorHandler(error!.localizedDescription)
                }
                
                return
            }
            
            self.finderMap.region = MKCoordinateRegion(center: response.mapItems[0].placemark.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            
            self.locationFound = response.mapItems[0]
            
            self.activityIndicator.stopAnimating()
        }
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
    
    private func dismissModal(){
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelModal(sender: AnyObject) {
        dismissModal()
    }

    @IBAction func submitPressed(sender: AnyObject) {
        
        let submitModel = StudentLocationModel(
            firstName: StudentData.firstName!,
            lastName: StudentData.lastName!,
            latitude: locationFound.placemark.coordinate.latitude,
            longitude: locationFound.placemark.coordinate.longitude,
            mapString: locationFound!.name!,
            mediaURL: mediaUrlTextField!.text!,
            uniqueKey: StudentData.userKey!
        )
        
        if(StudentData.student == nil){
            ParseAPI.instance.postStudentLocation(submitModel, completionHandler: submitRequestCompletionHandler, errorHandler: submitRequestErrorHandler)
        }else{
            ParseAPI.instance.putStudentLocation(submitModel, objectId: StudentData.student!.objectId!, completionHandler: submitRequestCompletionHandler, errorHandler: submitRequestErrorHandler)
        }
        
        
    }
    
    private func submitRequestCompletionHandler(){
        
        dismissModal()
        
    }
    private func submitRequestErrorHandler(errorMsg: String){
        activityIndicator.stopAnimating()
        
        let alertController = UIAlertController(title: "Error", message: errorMsg, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            print("OK")
        }
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    // keyboard detection
    
    func keyboardWillAppear(notification: NSNotification){
        
        
        let kHeight = getKeyboardHeight(notification)
        
        submitButtonViewBottomConstraint.constant = kHeight
        
        
    }
    
    
    func keyboardWillDisappear(notification: NSNotification){
        print("keyboard will disappear")
        
        submitButtonViewBottomConstraint.constant = 0
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // from Building MemeMe 1.0 Classroom
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }

}
