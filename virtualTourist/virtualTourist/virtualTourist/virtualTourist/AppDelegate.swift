//
//  AppDelegate.swift
//  virtualTourist
//
//  Created by Manal  harbi on 28/03/1441 AH.
//  Copyright © 1441 Udasity. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        DataControllor.shared.loading()
        
        return true
    }

    
    func saveContext (){
        try? DataControllor.shared.viewContext.save()
    }
   

    func applicationDidEnterBackground(_ application: UIApplication) {
        saveContext()
    }


    func applicationWillTerminate(_ application: UIApplication) {
        saveContext()
    }


}

