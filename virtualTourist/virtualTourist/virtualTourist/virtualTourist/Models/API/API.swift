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
    
    
      static func getPhotosUrl ( with coordinate: CLLocationCoordinate2D , pageNum: Int , completion: @escaping ([URL]? , String? ) -> () ) {
        
        let methodeParametrs = [Constant.flickerParametersKeys.Method : Constant.flickrParameterValues.SerchMethod , Constant.flickerParametersKeys.APIKey : Constant.flickrParameterValues.APIKey , //Constant.flickerParametersKeys.BoundingBox : BBoXString(lat: coordinate.latitude, lon: coordinate.longitude)
            Constant.flickerParametersKeys.lat: coordinate.latitude ,
            Constant.flickerParametersKeys.lon: coordinate.longitude
            , Constant.flickerParametersKeys.SafeSearch : Constant.flickrParameterValues.UseSafeSearch , Constant.flickerParametersKeys.Extras : Constant.flickrParameterValues.MediumIRL , Constant.flickerParametersKeys.Format : Constant.flickrParameterValues.ResponseFormat , Constant.flickerParametersKeys.NoJSONCallback : Constant.flickrParameterValues.DisableJSONCall , Constant.flickerParametersKeys.Page : pageNum , Constant.flickerParametersKeys.PerPage : 20] as [String : Any]
        
        
        let request = URLRequest(url: getURL(from: methodeParametrs))
        
        let task = URLSession.shared.dataTask(with: request ) { ( data , respose , error ) in
        
            
            guard ( error == nil ) else {
            completion(nil , "There was an error "  )
            return }
        
            let statusCode = (respose as! HTTPURLResponse ).statusCode
            
            guard statusCode >= 200 && statusCode <= 290 else {
               completion( nil , "There's a server error!" )
                return }
            
            guard let data = data else {
                completion( nil , "There's been an error parsing data" )
                return }
            
            
            guard let result = try! JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else { return }
            
            guard let stat = try! result["stat"] as? String , stat == "ok" else {
                completion( nil , "The status isn't OK" )
                return
            }
            
            
            guard let photoDict = result["photos"] as? [String:Any] else {
                completion(nil, "There's been an issue parsing photo data")
                return }
            
            guard let photosArray = photoDict["photo"] as? [[String:Any]] else { return }
            
            /*let photosURLs = photosArray.compactMap {
                photosDict -> URL? in
                
                guard let url = photosDict["url_m"] as? String else { return nil }
                
                return ( String: url )
                
            }*/
            
            var photoURL = [URL]()
            for photoDict in photosArray {
                guard let urlString = photoDict["url_m"] as? String else { return  }
                let url = URL(string: urlString)
                photoURL.append(url!)
            }
        
           completion( photoURL , nil )
        }
        task.resume()
    }
    

    static func BBoXString ( lat: Double , lon: Double ) -> String {
        
        
       // let lat = coordinate.latitude
        //let lon = coordinate.longitude
        
        let minLon = max( lon - Constant.flickr.searchBBoxWidth, Constant.flickr.longtudeRange.0)
        let minLat = max( lat - Constant.flickr.searchBBoxHeight, Constant.flickr.latitudeRange.0)
        let maxLat = max( lon + Constant.flickr.searchBBoxHeight,Constant.flickr.latitudeRange.1 )
        let maxLon = max( lon + Constant.flickr.searchBBoxWidth, Constant.flickr.longtudeRange.1 )
        
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


