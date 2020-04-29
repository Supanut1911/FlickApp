//
//  FlickRealmData.swift
//  FlickrApp
//
//  Created by Supanut Laddayam on 28/4/2563 BE.
//  Copyright © 2563 Supanut LDM. All rights reserved.
//

import Foundation
import RealmSwift

class FlickRealmData: Object {
    
    @objc dynamic var storeImage: String = ""
    @objc dynamic var storeLink: String = ""
}


