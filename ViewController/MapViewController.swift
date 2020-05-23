//
//  MapViewController.swift
//  Tourist
//
//  Created by Ecem Aleyna on 13.05.2020.
//  Copyright © 2020 Ecem Aleyna. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, UIGestureRecognizerDelegate, MKMapViewDelegate{
    
   
    
    @IBOutlet var dropLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var clickToThePinDropLabel: UILabel!
    var photoResponse: PhotoResponse? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setMapview()
        
        self.navigationItem.title = "TOURIST"
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        clickToThePinDropLabel.isHidden = true
        
        self.mapView.delegate = self
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        clickToThePinDropLabel.isHidden = !isEditing
    }
    
    func setMapview() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.handleLongPress(gestureReconizer:)))
        longPress.minimumPressDuration = 0.5
        longPress.delaysTouchesBegan = true
        longPress.delegate = self
        self.mapView.addGestureRecognizer(longPress)
        
    }

    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        
        if gestureReconizer.state != UIGestureRecognizer.State.ended {
            let touchLocation = gestureReconizer.location(in: mapView)
            let locationCoordinate = mapView.convert(touchLocation,toCoordinateFrom: mapView)
            print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
            
            addMarkerToMap(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
            
            ApiInteractor().getPhotoByLatLong(latitude: locationCoordinate.latitude,
                                   longitude: locationCoordinate.longitude,
                                   perPage: 30 ,
                                   completionHandler: { responseData in
                                      do {
                                        self.photoResponse = try JSONDecoder().decode(PhotoResponse.self, from: responseData)
                                      } catch let error {
                                           print("Json Parse Error : \(error)")
                                      }
                                   },
                                   failureHandler: { error in
                                       print("Weather Request Error : \(error)")
                                   })
            return
            }
        

        if gestureReconizer.state != UIGestureRecognizer.State.began {
            return
            }
    }
   
    func addMarkerToMap(latitude: Double, longitude: Double){
        let annotation = MKPointAnnotation()
        let coordinator = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.coordinate = coordinator
        annotation.subtitle = "\(round(1000*coordinator.latitude)/1000), \(round(1000*coordinator.longitude)/1000)"
        mapView.addAnnotation(annotation)
      //  let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 30000, longitudinalMeters: 30000)
     //   mapView.setRegion(region, animated: true)
        
   }
    
    func removeMarkerFromMap(coord: CLLocationCoordinate2D) {
        let allAnnotations = self.mapView.annotations
        for eachAnnotation in allAnnotations {
            if eachAnnotation.coordinate.latitude == coord.latitude || eachAnnotation.coordinate.longitude == coord.longitude {
                self.mapView.removeAnnotation(eachAnnotation)
            }
        }
    }
    
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhoto"  {
        
            let photosVC = segue.destination as! PhotoViewController
            photosVC.photoResponse = self.photoResponse
        
        }
    }
 
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
              let reuseId = "pin"
              var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
              
              if pinView == nil {
                  
                  pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                  pinView!.canShowCallout = true
                  pinView!.animatesDrop = true
              }
                  
              else {
                  
                  pinView!.annotation = annotation
              }

              return pinView
          }
    
       
          /* func mapView(_ mapView: MKMapView, annotation: MKAnnotation, calloutAccessoryControlTapped control: UIControl) {
               var annotationTitle = ""

           // mapView.deselectAnnotation(annotation, animated: true) // Hide the callout view.
           annotationTitle = annotation.title!!
           performSegue(withIdentifier: "showPhoto", sender: view)
       }
    
    */
       
       func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if isEditing {
            for annotation in self.mapView.annotations {
                if (annotation.title == view.annotation?.title) {
                    self.mapView.removeAnnotation(annotation)
                }
            }
        } else {
            self.performSegue(withIdentifier: "showPhoto", sender: nil)
        }
    }
    

}


