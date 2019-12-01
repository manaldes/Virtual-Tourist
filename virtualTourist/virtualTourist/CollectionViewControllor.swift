//
//  CollectionViewControllor.swift
//  virtualTourist
//
//  Created by Manal  harbi on 04/04/1441 AH.
//  Copyright © 1441 Udasity. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewControllor : UIViewController , UICollectionViewDelegate , UICollectionViewDataSource {
    
    
    
    @IBOutlet weak var message: UILabel!
    
    @IBOutlet weak var newCollection: UIBarButtonItem!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBAction func newCollectionTapped(_ sender: Any) {
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }

}
