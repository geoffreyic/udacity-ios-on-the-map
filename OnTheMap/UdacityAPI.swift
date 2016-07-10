//
//  UdacityAPI.swift
//  OnTheMap
//
//  Created by Geoffrey_Ching on 7/1/16.
//  Copyright © 2016 Geoffrey Ching. All rights reserved.
//

import Foundation

public class UdacityAPI{
    
    static let instance:UdacityAPI = UdacityAPI()
    
    private var sessionToken:String? = nil
    
    private var userKey:String!
    public func getUserKey()->String{
        return userKey
    }
    
    private var firstName:String!
    public func getFirstName()->String{
        return firstName
    }
    
    private var lastName:String!
    public func getLastName()->String{
        return lastName
    }
    
    private func handleInMainThread(codeInMain: ()->Void){
        dispatch_async(dispatch_get_main_queue()){
            codeInMain()
        }
    }
    
    private func checkErrorsParseObject(data: NSData?, error:NSError?, errorHandler: (errorMsg: String) -> Void) -> AnyObject?{
        print(error)
        
        
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
        
        let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
        print(NSString(data: newData, encoding: NSUTF8StringEncoding))
        
        
        var objectData:AnyObject!
        
        do{
            objectData = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
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
    
    public func authorizeAndGetSession(username:String, password:String, completionHandler: () -> Void, errorHandler: (errorMsg: String) -> Void){
        
        let requestBody = "{\"udacity\": {\"username\": \"" + username + "\", \"password\": \"" + password + "\"}}"
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = requestBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let session = NSURLSession.sharedSession()
        
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            let objectData = self.checkErrorsParseObject(data, error: error, errorHandler: errorHandler)
            if(objectData == nil){
                return
            }
            
            if let obj1 = objectData as? [String:AnyObject],
                status = obj1["status"] as? Int,
                error = obj1["error"] as? String where
                status != 200
            {
                self.handleInMainThread(){
                    errorHandler(errorMsg: error)
                }
                return
            }
            
            guard let obj1 = objectData as? [String:AnyObject],
                obj2 = obj1["account"] as? [String:AnyObject],
                registered = obj2["registered"] as? Bool,
                userKey = obj2["key"] as? String
            else{
                self.handleInMainThread(){
                    errorHandler(errorMsg: "Could not find whether valid account or not")
                }
                return
            }
            
            if(registered != true){
                self.handleInMainThread(){
                    errorHandler(errorMsg: "Not a valid account")
                }
                return
            }

            guard let obj3 = obj1["session"] as? [String:AnyObject],
                sessionTokenId = obj3["id"] as? String
                else{
                    self.handleInMainThread(){
                        errorHandler(errorMsg: "Could not find session token string")
                    }
                    return
            }
            self.sessionToken = sessionTokenId
            self.userKey = userKey
            
            self.handleInMainThread(){
                completionHandler()
            }
            
            
        }
        task.resume()
    }
    
    public func deleteSession(completionHandler: () -> Void, errorHandler: (errorMsg: String) -> Void){
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
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
    
    public func getUser(userId: String, completionHandler: () -> Void, errorHandler: (errorMsg: String) -> Void){
    
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/" + userId)!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            let objectData = self.checkErrorsParseObject(data, error: error, errorHandler: errorHandler)
            if(objectData == nil){
                return
            }
            
            guard let object = objectData as? [String:AnyObject],
                let user = object["user"] as? [String:AnyObject],
                let firstName = user["first_name"] as? String,
                let lastName = user["last_name"] as? String else{
                    self.handleInMainThread(){
                        errorHandler(errorMsg: "Could not find user data")
                    }
                    return
            }
            
            self.lastName = lastName
            self.firstName = firstName
            
            self.handleInMainThread(){
                completionHandler()
            }
        }
        task.resume()
    }

}