//
//  ApiInteractor.swift
//  Tourist
//
//  Created by Ecem Aleyna on 15.05.2020.
//  Copyright © 2020 Ecem Aleyna. All rights reserved.
//

import Foundation
import Alamofire

class ApiInteractor {
    
    typealias ApiCompletionHandler = (_ responseData: Data) -> Void
    typealias ApiFailureHandler = (_ error: Error) -> Void
    
    func getPhotoByLatLong(latitude: Double,
                           longitude: Double,
                           perPage: Int,
                           completionHandler: @escaping ApiCompletionHandler,
                           failureHandler: @escaping ApiFailureHandler) {
        
        AF.request(ApiClient.baseUrl + ApiClient.searchUrl,
                   parameters: [
                                "api_key": ApiClient.apiKey,
                                "lat":       latitude,
                                "lon":       longitude,
                                "per_page":  perPage,
                                "extras":     "url_m",
                                "format":    "json",
                                "nojsoncallback": 1
                                ],
                    encoding: URLEncoding.default).responseJSON { response in
                       
                        guard let data = response.data else { return }
                         do {
                            completionHandler(data)
                        } catch let error {
                            failureHandler(error)
                        }
                    }
        }
}
