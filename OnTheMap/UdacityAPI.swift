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
    
    init(){
        
    }
    
    private func handleInMainThread(codeInMain: ()->Void){
        dispatch_async(dispatch_get_main_queue()){
            codeInMain()
        }
    }
    
    public func authorizeAndGetSession(username:String, password:String, completionHandler: (sessionToken: String) -> Void, errorHandler: (errorMsg: String) -> Void){
        
        let requestBody = "{\"udacity\": {\"username\": \"" + username + "\", \"password\": \"" + password + "\"}}"
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = requestBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                print(error)
                self.handleInMainThread(){
                    errorHandler(errorMsg: "Could not fetch data")
                }
                return
            }
            
            if data == nil{
                print(error)
                self.handleInMainThread(){
                    errorHandler(errorMsg: "No data available")
                }
                return
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
                return
            }
            
            guard let obj1 = objectData as? [String:AnyObject],
                obj2 = obj1["account"] as? [String:AnyObject],
                registered = obj2["registered"] as? Bool
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
            
            self.handleInMainThread(){
                completionHandler(sessionToken: sessionTokenId)
            }
            
        }
        task.resume()
    }
    
    public func deleteSession(){
        
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
            if error != nil { // Handle error…
                return
            }
            if data == nil {
                return
                //handle error
            }
            
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
        }
        task.resume()
        
    }

}