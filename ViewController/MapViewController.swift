//
//  MapViewController.swift
//  Tourist
//
//  Created by Ecem Aleyna on 13.05.2020.
//  Copyright © 2020 Ecem Aleyna. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import CoreLocation

class MapViewController: UIViewController, UIGestureRecognizerDelegate, MKMapViewDelegate{
    
    @IBOutlet var dropLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var clickToThePinDropLabel: UILabel!
    var photoResponse: PhotoResponse? = nil
    
    var pinAnnotation : MKPointAnnotation?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setMapview()
        self.navigationItem.title = "TOURIST"
        navigationItem.rightBarButtonItem = editButtonItem
        clickToThePinDropLabel.isHidden = true
        self.mapView.delegate = self
        
        let pinList = MapViewController.fetchAll
        
        if pinList != nil && pinList.count > 0 {
            for pin in pinList {
                addMarkerToMap(latitude: pin.latitude, longitude: pin.longitude)
            }
        }
      
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
            if !isEditing{
               addMarkerToMap(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
               insert(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
            }
            
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
        self.pinAnnotation = annotation
        
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
            
            photosVC.pinAnnotation = self.pinAnnotation
        
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
        mapView.deselectAnnotation(view.annotation, animated: true)
        self.pinAnnotation = view.annotation as! MKPointAnnotation
            if isEditing {
            for annotation in self.mapView.annotations {
                if (annotation.isEqual(view.annotation)) {
                    self.mapView.removeAnnotation(annotation)
                    deletePin(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
                    
                }
                
                
            }
        } else {
                
            self.performSegue(withIdentifier: "showPhoto", sender: nil)
                
        }
    }
    
    
    func insert(latitude: Double, longitude: Double) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity =  NSEntityDescription.entity(forEntityName: "Pin", in:context)
        let newItem = Pin(entity: entity!, insertInto: context)

        newItem.latitude = latitude
        newItem.longitude = longitude

        do {
            try context.save()
    } catch {
        print(error)
    }
    
}
    
    
    static var fetchAll: [Pin] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
    
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        var pinList = [Pin]()
        do {
            pinList = try context.fetch(fetchRequest)
        } catch {
            
        }
    return pinList
}
    
    func deletePin(latitude: Double, longitude: Double) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        request.returnsObjectsAsFaults = false
            // If you want to delete data on basis of some condition then you can use NSPredicate
             let predicateDel = NSPredicate(format: "latitude == \(latitude) AND longitude == \(longitude)" )
             request.predicate = predicateDel
            
        do {
            let pinList = try context.fetch(request)
            for pin in pinList as! [NSManagedObject] { // Fetching Object
                context.delete(pin) // Deleting Object
            }
        } catch {
            print("Failed")
    }

        // Saving the Delete operation
        do {
            try context.save()
        } catch {
            print("Failed saving")
    }
        
}
    

}
