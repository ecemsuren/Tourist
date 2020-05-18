//
//  Photos.swift
//  Tourist
//
//  Created by Ecem Aleyna on 16.05.2020.
//  Copyright © 2020 Ecem Aleyna. All rights reserved.
//

import Foundation
struct Photos: Codable {
    let page, pages, perpage: Int
    let total: String
    let photo: [Photo]
}


