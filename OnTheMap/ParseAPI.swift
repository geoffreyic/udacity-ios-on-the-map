//
//  ParseAPI.swift
//  OnTheMap
//
//  Created by Geoffrey_Ching on 7/6/16.
//  Copyright © 2016 Geoffrey Ching. All rights reserved.
//

import Foundation

public class ParseAPI{
    
    static let instance:ParseAPI = ParseAPI()
    
    
    private let parseApplicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    private let parseRestApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    
    private var locationArr:[StudentLocationModel] = []
    
    public func getStudentLocations()->[StudentLocationModel]{
        
        return locationArr
    }
    
    private var studentLocation:StudentLocationModel? = nil
    public func getStudentLocation()->StudentLocationModel?{
        return studentLocation
    }
    
    
    public func loadStudentLocations(limit:Int, skip:Int, order:String, completionHandler: () -> Void, errorHandler: (errorMsg: String) -> Void){
        
        let urlString:String = "https://api.parse.com/1/classes/StudentLocation?limit=" + NSNumber(long: limit).stringValue + "&skip=" + NSNumber(long: skip).stringValue + "&order=" + order
        
        print(urlString)
        
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.addValue(self.parseApplicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(self.parseRestApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            
            let objectData = self.checkErrorsParseObject(data, error: error, errorHandler: errorHandler)
            if(objectData == nil){
                return
            }
            
            guard let resultsArr = objectData!["results"] as? [AnyObject] else{
                self.handleInMainThread(){
                    errorHandler(errorMsg: "could not find results object and cast as list")
                }
                return
            }
            
            
            self.locationArr.removeAll()
            
            for object in resultsArr{
                if let dict = object as? [String:AnyObject]{
                    self.locationArr.append(StudentLocationModel(dict: dict))
                }else{
                    self.handleInMainThread(){
                        errorHandler(errorMsg: "error looping through array of students")
                    }
                    return
                }
            }
            
            print("locationArr parsed")
            
            print(self.locationArr)
            
            self.handleInMainThread(){
                completionHandler()
            }
            
        }
        task.resume()
    }
    
    public func getStudentLocation(uniqueKey:String, completionHandler: () -> Void, errorHandler: (errorMsg: String) -> Void){
        
        let urlString = "https://api.parse.com/1/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%22" + uniqueKey + "%22%7D"
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.addValue(self.parseApplicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(self.parseRestApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            let objectData = self.checkErrorsParseObject(data, error: error, errorHandler: errorHandler)
            if(objectData == nil){
                return
            }

            
            guard let resultsArr = objectData!["results"] as? [AnyObject] else{
                self.handleInMainThread(){
                    errorHandler(errorMsg: "could not find results object and cast as list")
                }
                return
            }
            
            if(resultsArr.count == 0){
                self.studentLocation = nil
                self.handleInMainThread(){
                    completionHandler()
                }
                return
            }
            
            if let dict = resultsArr[0] as? [String:AnyObject]{
                self.studentLocation = StudentLocationModel(dict: dict)
            }else{
                self.handleInMainThread(){
                    errorHandler(errorMsg: "error looping through array of students")
                }
                return
            }
            
            print("student location parsed")
            
            print(self.studentLocation)
            
            self.handleInMainThread(){
                completionHandler()
            }
        }
        task.resume()
    }
    
    public func postStudentLocation(locationModel: StudentLocationModel, completionHandler: () -> Void, errorHandler: (errorMsg: String) -> Void){
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue(self.parseApplicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(self.parseRestApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = locationModel.toJson().dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            let objectData = self.checkErrorsParseObject(data, error: error, errorHandler: errorHandler)
            if(objectData == nil){
                return
            }
            
            self.handleInMainThread(){
                completionHandler()
            }
            
        }
        task.resume()
    }
    
    public func putStudentLocation(locationModel: StudentLocationModel, objectId:String, completionHandler: () -> Void, errorHandler: (errorMsg: String) -> Void){
        let urlString = "https://api.parse.com/1/classes/StudentLocation/" + objectId
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "PUT"
        request.addValue(self.parseApplicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(self.parseRestApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = locationModel.toJson().dataUsingEncoding(NSUTF8StringEncoding)

        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            let objectData = self.checkErrorsParseObject(data, error: error, errorHandler: errorHandler)
            if(objectData == nil){
                return
            }
            
            self.handleInMainThread(){
                completionHandler()
            }
        }
        task.resume()
    }
    
    
    private func handleInMainThread(codeInMain: ()->Void){
        dispatch_async(dispatch_get_main_queue()){
            codeInMain()
        }
    }
    
    private func checkErrorsParseObject(data: NSData?, error:NSError?, errorHandler: (errorMsg: String) -> Void) -> AnyObject?{
        print(error)
        
        print(NSString(data: data!, encoding: NSUTF8StringEncoding))
        
        
        if error != nil {
            print(error)
            self.handleInMainThread(){
                errorHandler(errorMsg: "Could not fetch data")
            }
            return nil
        }
        
        if data == nil{
            print(error)
            self.handleInMainThread(){
                errorHandler(errorMsg: "No data available")
            }
            return nil
        }
        
        // add check for http response code
        
        
        var objectData:AnyObject!
        
        do{
            objectData = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
        }catch{
            self.handleInMainThread(){
                errorHandler(errorMsg: "Could not parse JSON object")
            }
            return nil
        }
        
        if let object = objectData as? [String:AnyObject],
            let error = object["error"] as? String{
            self.handleInMainThread(){
                errorHandler(errorMsg: error)
            }
            return nil
        }
        
        return objectData
        
    }
}