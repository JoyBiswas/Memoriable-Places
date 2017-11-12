//
//  ViewController.swift
//  Memoriable Places
//
//  Created by MacBook Air on 11/11/17.
//  Copyright © 2017 MacBook Air. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate{
    
    var manager = CLLocationManager()
    
    @IBOutlet var mapView: MKMapView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longpress(gestureRecgnizer:)) )
            uilpgr.minimumPressDuration = 2
            mapView.addGestureRecognizer(uilpgr)
        
        if  activePlace == -1 {
            
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestAlwaysAuthorization()
            manager.stopUpdatingLocation()
            
        }else {
        
            if places.count>activePlace {
                
                if let name = places[activePlace]["name"] {
                    
                    if let lat = places[activePlace]["lat"] {
                        
                        if let lon = places[activePlace]["lon"] {
                            
                            if let latitute = Double(lat) {
                                
                                if let longitute = Double(lon) {
                                    
                                     let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                        
                                         let cordinates = CLLocationCoordinate2D(latitude: latitute, longitude: longitute)
                                    
                                          let region = MKCoordinateRegion(center: cordinates, span: span)
                                    
                                          self.mapView.setRegion(region, animated: true)
                                            
                                          let annotation = MKPointAnnotation()
                                    
                                              annotation.coordinate = cordinates
                                              annotation.title = name
                                    
                                              self.mapView.addAnnotation(annotation)
                                    
                                    
                                    
                                    
                                }
                            }
                        
                        }
                    }
                }
            }
            
        }
    
    }
    
    func longpress(gestureRecgnizer:UIGestureRecognizer) {
        
        if gestureRecgnizer.state == UIGestureRecognizerState.began {
            
        let touchpoint = gestureRecgnizer.location(in: self.mapView)
        
        let newCoordinates = self.mapView.convert(touchpoint, toCoordinateFrom: self.mapView)
            
        let location = CLLocation(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude)
            
        var title = ""
            
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            
            if error != nil {
                print(error!)
            }else {
                
                if let placemark = placemarks?[0] {
                    
                    if placemark.subThoroughfare != nil {
                        
                        title += placemark.subThoroughfare! + " "
                    }
                    if placemark.thoroughfare != nil {
                        
                        title += placemark.thoroughfare! + " "
                    }
                    
                }
            }
            if title == "" {
                
                title = "Added\(NSDate())"
            }
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = newCoordinates
            
            print(annotation.coordinate)
            
            annotation.title = title
            self.mapView.addAnnotation(annotation)
        places.append(["name":title,"lat":String(newCoordinates.latitude),"lon":String(newCoordinates.longitude)])
            
            UserDefaults.standard.set(places, forKey: "places")

            
          })
            
       }
        
    }
    // for updating adjust location and you can see annotation at the middle of the view
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        
        self.mapView.setRegion(region, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

