# Virtual Tourist app

The iOS app that allows users to visit virtual locations by drop pins on a map. Once a user taps a pin the app downloaded photos and stores images from Flickr for that location. Users will also be able to drop pin in new location to download new pictures and will be able to delete photos from collectionView by click on photo.The user can refresh the generated photo collection anytime from inside the collectionView.


# Implementation

The app has two view controller scenes:

* MapViewController - shows the map and allows user to drop pins around the world by long pressed in location. As soon as a pin is dropped photo data for the pin location is fetched from Flickr.

* PhotoAlbumVC - allow users to fetch photos and delete a photo for a location. Users can create new collections and delete photos from existing albums by click on photo. Users will also be able to refresh the generated photo anytime from inside the collectionView.

Application uses CoreData to store Pins and Photos. Preloaded files saved in memory cache (NSCache) and file system (NSFileManager) and removed as soon as Photo object removed from CoreData.


# How to build

It was built using Xcode Version Version 10.3 along with Swift 5.

* Clone repo

` git clone https://github.com/manaldes/Virtual-Tourist.git `

* Install dependences (CocoaPods needed)
` pod install `

* Insert flicker API key & secret inside -> (Virtual\ Tourist/API/FlickrAPI.swift) left my key & secret for ease of building

` class Constant {

struct flickrParameterValues {
        
        static let SerchMethod = "flickr.photos.search"
        static let APIKey = //here
        static let ResponseFormat = "json"
        static let DisableJSONCall = "1"
        static let GalleryPhotosMethod = "flickr.galleries.getPhotos"
        static let MediumIRL = "url_m"
        static let UseSafeSearch = "1"
        
    }
}`

* Open Virtual Tourist.xcworkspace

* Build app for your device or simulator


# Requirements

* Xcode +9
* Swift +4.0


# License

Copyright (c) 2019 Manal Alharbi. All rights reserved.

