//
//  MyImageView.swift
//  virtualTourist
//
//  Created by Manal  harbi on 07/04/1441 AH.
//  Copyright © 1441 Udasity. All rights reserved.
//

import UIKit
import Foundation


let imageCashe = NSCache<NSString,AnyObject >()

class myImageView :UIImageView {
    
    var imageurls : URL!
    
    func setPhoto ( _ newPhoto: Photo ){
        if photo != nil {
            return
        } else {
            photo = newPhoto
        }
    }
    
    private var photo : Photo! {
        didSet {
            
            if let image = photo.getImage() {
             stopAnimating()
                
            self.image = image
            return
            }
            
            guard let url = photo.imageURL else { return }
            
            loadImageUsingCashe (with: url )
    }
}
    
    
    func loadImageUsingCashe (with  url: URL ){
        
        imageurls = url
        image = nil
        startAnimating()
        
        if let casheImage = imageCashe.object(forKey: url.absoluteString as NSString )  as? UIImage {
            image = casheImage
            stopAnimating()
            return
        }
        
        URLSession.shared.dataTask( with: url) { ( data , response , error  ) in
            
            guard error == nil else { return }
            
            guard let downloadImage = UIImage(data: data!) else { return }
            
            imageCashe.setObject(downloadImage, forKey: url.absoluteString as NSString )
            
            DispatchQueue.main.async {
                self.image = downloadImage
                try? self.photo.managedObjectContext?.save()
                self.stopAnimating()
                
            }
        
    }
        
        .resume()



}
}
