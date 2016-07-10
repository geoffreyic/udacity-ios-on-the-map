//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Geoffrey_Ching on 7/1/16.
//  Copyright © 2016 Geoffrey Ching. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: LocationBaseViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private var studentLocations: [StudentLocationModel]!
    
    private var annotationViewSelected: MKPinAnnotationView?
    private var annotationTapAction: UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        segueId = "MapToAddLocation"
        
        annotationTapAction = UITapGestureRecognizer(target: self, action: #selector(MapViewController.annotationTapped(_:)))
        annotationTapAction.delegate = self
        
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
    
    
    private func getLocationsComplete(){
        studentLocations = ParseAPI.instance.getStudentLocations()
        
        var annotations = [StudentAnnotation]()
        
        
        for student in studentLocations{
            annotations.append(StudentAnnotation(student: student))
        }
        
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        self.mapView.addAnnotations(annotations)
    }
    private func getLocationsError(errorMsg: String){
        displayErrorAlert(self, errorMsg: errorMsg)
    }
    
    
    
    
    @IBAction func refreshAction(sender: AnyObject) {
        ParseAPI.instance.loadStudentLocations(200, skip: 0, order: "updatedAt", completionHandler: getLocationsComplete, errorHandler: getLocationsError)
    }
    
    func annotationTapped(sender: MapViewController){
        if let studentAnnotation = annotationViewSelected!.annotation as? StudentAnnotation,
            let url = NSURL(string: studentAnnotation.student.mediaURL)
        {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    
    
    // map view functions
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let annotation = annotation as! StudentAnnotation
        
        let id = "pin"
        var view: MKPinAnnotationView
        
        if let v = mapView.dequeueReusableAnnotationViewWithIdentifier(id) as? MKPinAnnotationView {
            v.annotation = annotation
            view = v
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: id)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
        }
        return view
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        view.addGestureRecognizer(annotationTapAction)
        annotationViewSelected = view as? MKPinAnnotationView
    }
    
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        annotationViewSelected = nil
        view.removeGestureRecognizer(annotationTapAction)
    }

}
