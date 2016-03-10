//
//  ViewController.swift
//  CoreLocationVideo
//
//  Created by student on 10/03/16.
//  Copyright © 2016 BRN. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController,CLLocationManagerDelegate {

   var locationManager=CLLocationManager()
    var myposition=CLLocationCoordinate2D()
    
    
    @IBOutlet var mapVIew: MKMapView!
    @IBOutlet var labelLocation: UILabel!
    
    //create a new Varible  destination for Direction
    var destination:MKMapItem=MKMapItem()

    @IBAction func startAction(sender: UIButton)
    {
        locationManager.startUpdatingLocation()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate=self
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        
        //add pins
        
        let locationCordinate=CLLocationCoordinate2D(latitude: 25.12, longitude: 55.123)
        
        let annotation=MKPointAnnotation()
        annotation.coordinate=locationCordinate
        annotation.title="my location"
        annotation.subtitle="location Style"

        mapVIew.addAnnotation(annotation)
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated. 17.448293,78.391485
    }
 
    
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation)
    {
        
        
        
        print("got Location\(newLocation.coordinate.latitude),\(newLocation.coordinate.longitude)")
        myposition=newLocation.coordinate
        labelLocation.text="\(newLocation.coordinate.latitude),\(newLocation.coordinate.longitude)"
    
        let span=MKCoordinateSpanMake(0.5, 0.5)
        let region=MKCoordinateRegion(center: newLocation.coordinate, span: span)
        mapVIew.setRegion(region, animated:true)
         locationManager.stopUpdatingLocation()
        
        
    }
    
    @IBAction func showDirection(sender: AnyObject)
    {
        //Need to create a mkDirection Request
        let request=MKDirectionsRequest()
        request.setSource(MKMapItem.mapItemForCurrentLocation())
        request.setDestination(destination)
        request.requestsAlternateRoutes=false
        let directions=MKDirections(request: request)
        directions.calculateDirectionsWithCompletionHandler(
            {
                (response:MKDirectionsResponse!,error:NSError!) in
            
                if error != nil
                {
                print("Error \(error)")
            }
            else
            {
                //self.displayRout(response)
                
                var overLay=self.mapVIew.overlays
                self.mapVIew.removeOverlay(overLay)
                for route in response.routes  as! [MKRoute]
                {
                    mapVIew.addOverlay(route.polyline,level:MKOverlayLevel.AboveRoads)
                    for next in route.steps
                    {
                        print(next.instructions)
                    }
                }
                
                
                
                
            }
        
        
    })
        
    }

    

    @IBAction func addPin(sender: UILongPressGestureRecognizer)
    {
        
        let location=sender.locationInView(mapVIew)
        
        let locCord=mapVIew.convertPoint(location, toCoordinateFromView: mapVIew)
        let annotation=MKPointAnnotation()
        annotation.coordinate=locCord
        annotation.title="Store"
        annotation.subtitle="Location In Store"
        
        
        //create a place mark and map  item
        let placeMark=MKPlacemark(coordinate: locCord, addressDictionary: nil)
        
        //this is needed when we neew to get direction
        destination=MKMapItem(placemark: placeMark)
        
        
        
        
      //  mapVIew.removeAnnotation(mapVIew.annotations)
        mapVIew.addAnnotation(annotation)


    }
    
    func mapView(mapView:MKMapView!,rendereForOverlay overlay:MKOverlay!)->MKOverlayRenderer
    {
        let draw=MKPolylineRenderer(overlay: overlay)
        draw.strokeColor=UIColor.purpleColor()
        draw.lineWidth=3.0
        return draw
    }
      

}

