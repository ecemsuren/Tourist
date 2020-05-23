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


class PhotoViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var photoResponse: PhotoResponse? = nil
    
    //var photoResponse = [PhotoResponse]()
   
    let items = ["0","1","2"]
    
    @IBOutlet var photoMapView: MKMapView!
    @IBOutlet var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
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
       
}
