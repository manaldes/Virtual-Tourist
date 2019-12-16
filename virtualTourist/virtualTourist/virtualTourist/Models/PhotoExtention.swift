//
//  PhotoExtention.swift
//  virtualTourist
//
//  Created by Manal  harbi on 04/04/1441 AH.
//  Copyright © 1441 Udasity. All rights reserved.
//

import UIKit

extension Photo {
    
    func setImage (image : UIImage){
        self.image = image.pngData()
    }
    
    func getImage() -> UIImage? {
        
        guard image != nil else { return nil }
        
        return UIImage(data: image!)
        
    }
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
    
}
