//
//  APIService.swift
//  Flicko
//
//  Created by Gohar on 10/11/2018.
//  Copyright © 2018 AG. All rights reserved.
//

import UIKit

class APIService {
    
    let galleryID = "72157694049263781"
    lazy var endPoint: String = {
        return Constants.baseUrl + "&\(Constants.galleryEndpoint)=\(galleryID)" + "&\(Constants.apiKeyEndpoint)=\(Constants.apiKey)"
    }()
    
    
    func getDataWith(completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        
        LoadingMontion.sharedInstance.showActivityIndicator()
        
        guard let url = URL(string:endPoint ) else { return completion(.Error("Invalid URL, we can't update your feed")) }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else { return completion(.Error(error!.localizedDescription)) }
            guard let data = data else { return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                    if let photosDict = json["photos"] as? [String: AnyObject] {
                        guard let itemsJsonArray = photosDict["photo"] as? [[String: AnyObject]] else {
                            return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))
                        }
                        DispatchQueue.main.async {
                            completion(.Success(itemsJsonArray))
                            LoadingMontion.sharedInstance.hideActivityIndicator()
                        }
                    }
                   
                }
            } catch let error {
                return completion(.Error(error.localizedDescription))
            }
        }.resume()
    }
}
