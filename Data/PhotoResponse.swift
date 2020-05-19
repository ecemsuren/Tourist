//
//  Photos.swift
//  Tourist
//
//  Created by Ecem Aleyna on 16.05.2020.
//  Copyright © 2020 Ecem Aleyna. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let photoResponse = try? newJSONDecoder().decode(PhotoResponse.self, from: jsonData)

import Foundation

// MARK: - PhotoResponse
struct PhotoResponse: Codable {
    let photos: Photos
    let stat: String

}
