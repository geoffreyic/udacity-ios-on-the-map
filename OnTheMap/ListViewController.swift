//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Geoffrey_Ching on 7/8/16.
//  Copyright © 2016 Geoffrey Ching. All rights reserved.
//

import UIKit

class ListViewController: LocationBaseViewController, UITableViewDelegate {
    
    @IBOutlet weak var studentLocationTableView: UITableView!
    
    private var studentLocations:[StudentLocationModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        segueId = "ListToAddLocation"
        
        if (ParseAPI.instance.getStudentLocations().count == 0){
            ParseAPI.instance.loadStudentLocations(200, skip: 0, order: "updatedAt", completionHandler: getLocationsComplete, errorHandler: getLocationsError)
        }else{
            getLocationsComplete()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func refreshAction(sender: AnyObject) {
        ParseAPI.instance.loadStudentLocations(200, skip: 0, order: "updatedAt", completionHandler: getLocationsComplete, errorHandler: getLocationsError)
    }
    
    
    private func getLocationsComplete(){
        studentLocations = ParseAPI.instance.getStudentLocations().reverse()
        
        studentLocationTableView.reloadData()
    }
    private func getLocationsError(errorMsg: String){
        displayErrorAlert(self, errorMsg: errorMsg)
    }
    
    // Table Functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentLocationCell", forIndexPath: indexPath)
        
        
        cell.textLabel?.text = studentLocations[indexPath.row].firstName + " " + studentLocations[indexPath.row].lastName
        cell.detailTextLabel!.text = studentLocations[indexPath.row].mediaURL
        cell.imageView?.image = UIImage(named: "pin")
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
        
        if let url = NSURL(string: studentLocations[indexPath.row].mediaURL)
        {
            UIApplication.sharedApplication().openURL(url)
        }
    }
}
