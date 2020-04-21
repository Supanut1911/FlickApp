//
//  FlickData.swift
//  FlickrApp
//
//  Created by Supanut Laddayam on 22/4/2563 BE.
//  Copyright © 2563 Supanut LDM. All rights reserved.
//

import Foundation


struct FlickData: Codable{
    var items: [Items]
}

struct Items: Codable {
    var link: String
    var media: Media
}

struct Media: Codable {
    var m: String
}

