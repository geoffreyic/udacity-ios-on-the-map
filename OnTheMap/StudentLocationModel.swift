//
//  PostStudentLocationModel.swift
//  OnTheMap
//
//  Created by Geoffrey_Ching on 7/6/16.
//  Copyright © 2016 Geoffrey Ching. All rights reserved.
//

import Foundation
import MapKit

public struct StudentLocationModel{
    
    public var uniqueKey:String!
    public var firstName:String!
    public var lastName:String!
    public var mapString:String!
    public var mediaURL:String!
    public var latitude:Double!
    public var longitude:Double!
    public var objectId:String?
    
    
    public init(dict:[String:AnyObject]){
        if let firstName = dict["firstName"] as? String {
            self.firstName = firstName
        }
        if let lastName = dict["lastName"] as? String {
            self.lastName = lastName
        }
        if let latitude = dict["latitude"] as? Double {
            self.latitude = latitude
        }
        if let longitude = dict["longitude"] as? Double {
            self.longitude = longitude
        }
        if let mapString = dict["mapString"] as? String {
            self.mapString = mapString
        }
        if let mediaURL = dict["mediaURL"] as? String {
            self.mediaURL = mediaURL
        }
        if let uniqueKey = dict["uniqueKey"] as? String {
            self.uniqueKey = uniqueKey
        }
        if let objectId = dict["objectId"] as? String {
            self.objectId = objectId
        }
    }
    
    public init(firstName: String, lastName: String, latitude: Double, longitude: Double, mapString: String, mediaURL: String, uniqueKey: String){
        self.firstName = firstName
        self.lastName = lastName
        self.latitude = latitude
        self.longitude = longitude
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.uniqueKey = uniqueKey
    }
    
    
    public func toJson()-> NSString{
        
        var string:NSString! = ""
        
        let model:NSDictionary = [
            "uniqueKey": uniqueKey,
            "firstName": firstName,
            "lastName": lastName,
            "mapString": mapString,
            "mediaURL": mediaURL,
            "latitude": latitude,
            "longitude": longitude
        ]
        
        do{
            let data = try NSJSONSerialization.dataWithJSONObject(model, options: NSJSONWritingOptions.PrettyPrinted)
            string = NSString(data: data, encoding: NSUTF8StringEncoding)
            print(string)
        }catch{
            
        }
        return string
    }
}