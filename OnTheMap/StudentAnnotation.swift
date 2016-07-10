//
//  StudentAnnotation.swift
//  OnTheMap
//
//  Created by Geoffrey_Ching on 7/10/16.
//  Copyright © 2016 Geoffrey Ching. All rights reserved.
//

import Foundation
import MapKit

class StudentAnnotation: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var student: StudentLocationModel
    
    init(student: StudentLocationModel){
        self.student = student
        coordinate = CLLocationCoordinate2D(latitude: student.latitude, longitude: student.longitude)
        title = student.firstName + " " + student.lastName
        subtitle = student.mediaURL
    }
    
}