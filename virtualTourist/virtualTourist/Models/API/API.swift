//
//  API.swift
//  virtualTourist
//
//  Created by Manal  harbi on 04/04/1441 AH.
//  Copyright © 1441 Udasity. All rights reserved.
//

import Foundation
import MapKit
import UIKit


class API {
    
   //static let shared = API()
    
    
      static func getPhotosUrl ( with coordinate: CLLocationCoordinate2D , pageNum: Int , completion: @escaping ([URL]? , Error? ) -> () ) {
        
        let methodeParametrs = [Constant.flickerParametersKeys.Method : "method" , Constant.flickerParametersKeys.APIKey : Constant.flickrParameterValues.APIKey , Constant.flickerParametersKeys.BoundingBox : BBoXString(for: coordinate) , Constant.flickerParametersKeys.SafeSearch : Constant.flickrParameterValues.UseSafeSearch , Constant.flickerParametersKeys.Extras : Constant.flickrParameterValues.MediumIRL , Constant.flickerParametersKeys.Format : Constant.flickrParameterValues.ResponseFormat , Constant.flickerParametersKeys.NoJSONCallback : Constant.flickrParameterValues.DisableJSONCall , Constant.flickerParametersKeys.Page : pageNum , Constant.flickerParametersKeys.PerPage : 1  ] as [String:Any]
        
        
        let request = URLRequest(url: getURL(from: methodeParametrs))
        
        let task = URLSession.shared.dataTask(with: request ) { ( data , respose , error ) in
        
            
            guard ( error == nil ) else {
            completion(nil , error  )
            return }
        
            let statusCode = (respose as! HTTPURLResponse ).statusCode
            
            guard statusCode >= 200 && statusCode <= 290 else {
               completion( nil , nil )
                return }
            
            guard let data = data else {
                completion( nil , nil )
                return }
            
            
            let jsonObject = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
            let stat = try! jsonObject["stat"] as?  String
            
            
            guard  stat == "ok" else {
                completion( nil , nil )
                return
            }
            
            
            guard let photosDict = jsonObject["photos"] as? [String:Any] else { return }
            guard let photosArray = photosDict["photo"] as? [String:Any] else { return }
            
            /*let photosURLs = photosArray.compactMap {
                photosDict -> URL? in
                
                guard let url = photosDict["url_m"] as? String else { return nil }
                
                return ( String: url )
                
            }*/
            
            var photoURL = [URL]()
            for photoDict in photosArray {
            
                guard let urlString = photosDict["url_m"] as? String else { return  }
                let url = URL(string: urlString)
                photoURL.append(url!)
            }
            
            
            
           completion( photoURL , nil )
        }
        
        task.resume()
        
    }
    

    static func BBoXString ( for coordinate :CLLocationCoordinate2D ) -> String {
        
        
        var lat = coordinate.latitude
        var lon = coordinate.longitude
        
        let minLon = max( lon - Constant.flickr.searchBBoxWidth, -180)
        let minLat = max( lat - Constant.flickr.searchBBoxHeight, -90.0)
        let maxLat = max( lon + Constant.flickr.searchBBoxHeight, 180 )
        let maxLon = max(lon + Constant.flickr.searchBBoxWidth, 90 )
        
        return "\(minLon),\(minLat),\(maxLat),\(maxLon)"
        
    }
    
    
    static func getURL ( from parametes: [String:Any] ) -> URL {
        
        var component = URLComponents()
        
        component.scheme = Constant.flickr.APIScheme
        component.host = Constant.flickr.APIHost
        component.path = Constant.flickr.APIPath
        component.queryItems = [URLQueryItem]()
        
        
        for ( key , value ) in parametes {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            component.queryItems!.append(queryItem)
        }
        
        
        return component.url!
        
    }
}


