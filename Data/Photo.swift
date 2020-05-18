//
//  Photo.swift
//  Tourist
//
//  Created by Ecem Aleyna on 16.05.2020.
//  Copyright © 2020 Ecem Aleyna. All rights reserved.
//

import Foundation
struct Photo: Codable {
let id, owner, secret, server: String
let farm: Int
let title: String
let ispublic, isfriend, isfamily: Int
let urlM: String
let heightM, widthM: Int

enum CodingKeys: String, CodingKey {
    case id, owner, secret, server, farm, title, ispublic, isfriend, isfamily
    case urlM = "url_m"
    case heightM = "height_m"
    case widthM = "width_m"
    }
}
