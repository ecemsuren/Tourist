//
//  PhotoViewController.swift
//  Tourist
//
//  Created by Ecem Aleyna on 17.05.2020.
//  Copyright © 2020 Ecem Aleyna. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Kingfisher



class PhotoViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, MKMapViewDelegate {
    
    var photoResponse: PhotoResponse? = nil
    
    var pinAnnotation : MKPointAnnotation?

    
    @IBOutlet var photoMapView: MKMapView!
    @IBOutlet var collectionView: UICollectionView!
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.photoMapView.delegate = self
        photoMapView.isZoomEnabled = false
        photoMapView.isScrollEnabled = false
        
        addMarkerToMap(latitude: (pinAnnotation?.coordinate.latitude)!, longitude: (pinAnnotation?.coordinate.longitude)!)
        
        ApiInteractor().getPhotoByLatLong(latitude: (pinAnnotation?.coordinate.latitude)!,
                                                     longitude: (pinAnnotation?.coordinate.longitude)!,
                                                     perPage: 30 ,
                                                     completionHandler: { responseData in
                      do {
                        self.photoResponse = try JSONDecoder().decode(PhotoResponse.self, from: responseData)
                        self.collectionView.reloadData()
                      } catch let error {
                           print("Json Parse Error : \(error)")
                      }
                   },
                   failureHandler: { error in
                       print("Photo Request Error : \(error)")
                   })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
   
        return 10
            //(photoResponse?.photos.photo.count)!
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoCollectionViewCell
        
        
        let url = URL(string: self.photoResponse?.photos.photo[indexPath.row].urlM ?? "")
        let processor = DownsamplingImageProcessor(size: cell.photoImageView.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 1)
        cell.photoImageView.kf.indicatorType = .activity
        cell.photoImageView.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
   
        return cell
       }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
    }
    
    func addMarkerToMap(latitude: Double, longitude: Double){
            let annotation = MKPointAnnotation()
            let coordinator = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            annotation.coordinate = coordinator
            annotation.subtitle = "\(round(1000*coordinator.latitude)/1000), \(round(1000*coordinator.longitude)/1000)"
            photoMapView.addAnnotation(annotation)
            self.pinAnnotation = annotation

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
       
}
