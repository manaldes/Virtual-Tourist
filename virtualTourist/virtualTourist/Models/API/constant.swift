//
//  constant.swift
//  virtualTourist
//
//  Created by Manal  harbi on 04/04/1441 AH.
//  Copyright © 1441 Udasity. All rights reserved.
//

import Foundation
import UIKit

class Constant {
    
    struct flickr {
        static let APIScheme = "https"
        static let APIHost = "api.flickr.com"
        static let APIPath = "/services/rest"
        
        static let searchBBoxHeight = 1.0
        static let searchBBoxWidth = 1.0
        static let latitudeRange = (-90.0 , 90.0 )
        static let longtudeRange = (-180.0 , 180.0 )
        
    }
    
    
    struct flickerParametersKeys {
        
         static let Method = "method"
         static let APIKey = "api_key"
         static let Extras = "extras"
         static let Format = "format"
         static let NoJSONCallback = "nojsoncallback"
         static let SafeSearch = "safe_search"
         static let Text = "text"
         static let BoundingBox = "bbox"
         static let Page = "page"
         static let PerPage = "per_page"
        
        
    }
    
    struct flickrParameterValues {
        
        static let SerchMethod = "flickr.photos.search"
        static let APIKey = "90dcb10ca78d1ea6406a7a0a053d0d39"
        static let ResponseFormat = "json"
        static let DisableJSONCall = "1"
        static let GalleryPhotosMethod = "flickr.galleries.getPhotos"
        static let MediumIRL = "url_m"
        static let UseSafeSearch = "1"
        
    }
    
    
    
}
