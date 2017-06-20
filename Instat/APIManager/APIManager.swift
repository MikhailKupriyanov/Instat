//
//  APIManager.swift
//  Instat
//
//  Created by mpkupriyanov on 17.06.17.
//  Copyright © 2017 mpkupriyanov. All rights reserved.
//

import Foundation

class APIManager {
    
    private let session = URLSession(configuration: URLSessionConfiguration.default)
    private let url = URL(string: "https://api.myjson.com/bins/guvjp")!
    
    func requestData(completion: @escaping (_ success: [String : AnyObject]) -> Void) {
        
        let task = session.dataTask(with: url) { (Data, response, error) in
            guard let data = Data, error == nil else {
                print("error= \(error!.localizedDescription)")
                return
            }
            
            // JSON Serialization
            let responseString  = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : AnyObject]
            completion(responseString)
            
        }
        task.resume()
    }
    
}
