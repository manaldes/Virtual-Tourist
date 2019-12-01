//
//  DataController.swift
//  virtualTourist
//
//  Created by Manal  harbi on 04/04/1441 AH.
//  Copyright © 1441 Udasity. All rights reserved.
//

import Foundation
import CoreData

class DataControllor {
    
    static let sharedInstanse = DataControllor()
    
    let persistentContainer = NSPersistentContainer(name: "virtualTourist")
    
    var viewContext : NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    
    func loading () {
        
        persistentContainer.loadPersistentStores { (storeDescription , error ) in
        
            guard error == nil else {
            fatalError(error!.localizedDescription)
        }
    }
}

}
