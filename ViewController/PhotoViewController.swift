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
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateFlowLayout(view.frame.size)
        self.photoMapView.delegate = self
        photoMapView.isZoomEnabled = false
        photoMapView.isScrollEnabled = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
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
        return photoResponse?.photos.photo.count ?? 0
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
            photoMapView.setCenter(coordinator, animated: true)
            self.pinAnnotation = annotation

             }
    
    private func updateFlowLayout(_ withSize: CGSize) {
        
        let landscape = withSize.width > withSize.height
        
        let space: CGFloat = landscape ? 5 : 3
        let items: CGFloat = landscape ? 2 : 3
        
        let dimension = (withSize.width - ((items + 1) * space)) / items
        
        flowLayout?.minimumInteritemSpacing = space
        flowLayout?.minimumLineSpacing = space
        flowLayout?.itemSize = CGSize(width: dimension, height: dimension)
        flowLayout?.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
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
