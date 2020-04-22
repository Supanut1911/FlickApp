//
//  FlickManager.swift
//  FlickrApp
//
//  Created by Supanut Laddayam on 22/4/2563 BE.
//  Copyright © 2563 Supanut LDM. All rights reserved.
//

import Foundation
import Alamofire

struct FlickManager {
    
    func fetchFlick(urlString: String, completion: @escaping (Result<FlickData, Error>) -> Void) {
        AF.request(urlString).responseDecodable(of: FlickData.self,queue: .main, decoder: JSONDecoder()) { (response) in
            switch response.result {
            case .success(let flickDatas):
                completion(.success(flickDatas))
            
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
