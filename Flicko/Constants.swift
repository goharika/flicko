//
//  Constants.swift
//  Flicko
//
//  Created by Gohar on 09/11/2018.
//  Copyright © 2018 AG. All rights reserved.
//

import UIKit

final class Constants {
    //MARK: API
    static let baseUrl = "https://api.flickr.com/services/rest?method=flickr.galleries.getPhotos&extras=url_m&format=json&nojsoncallback=1"
    static let apiKey = "057ae09f0ff8b5a196b747bdb7865ffc"
    // Endpoints
    static let galleryEndpoint = "gallery_id"
    static let apiKeyEndpoint = "api_key"
    
    //MARK: Cell identifires
    static let kGalleryIdentifier = "kGalleryIdentifier"
    
}

// URL example for test
// https://api.flickr.com/services/rest?method=flickr.galleries.getPhotos&extras=url_m&format=json&nojsoncallback=1&gallery_id=72157699580361272&api_key=057ae09f0ff8b5a196b747bdb7865ffc

// flicko
// Key:
//   057ae09f0ff8b5a196b747bdb7865ffc


//   Secret:
//   fe66f9f5fa0ca8dd
