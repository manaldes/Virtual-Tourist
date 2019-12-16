//
//  PhotoAlbumVC.swift
//  virtualTourist
//
//  Created by Manal  harbi on 08/04/1441 AH.
//  Copyright © 1441 Udasity. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class PhotoAlbumVC : UIViewController , UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout,  NSFetchedResultsControllerDelegate {
  
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var newCollection: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
     var selectedIndexPaths = [NSIndexPath]()
    
    var fetchedResultControllor : NSFetchedResultsController<Photo>!
    var pin : Pin!
    var isDEleting : Bool = true
    var pageNum = 1
    
    var context : NSManagedObjectContext {
        return DataControllor.shared.viewContext
    }
    
    var havePhotos : Bool {
        return (fetchedResultControllor.fetchedObjects?.count ?? 0 ) != 0
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResult()
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fetchedResultControllor = nil
    }
    
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        collectionView.reloadData()
    }
    
    
    // Mark: update UI
    func updateUI ( processing: Bool ){
        
        collectionView.isUserInteractionEnabled = !processing
        if processing {
            newCollection.title = ""
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            newCollection.title = "new Collection "
        }
    }
   
    
    @IBAction func newCollectionTapped(_ sender: Any) {
        
        updateUI(processing: true)
        
        if havePhotos {
            isDEleting = true
            for photo in fetchedResultControllor.fetchedObjects!{
                context.delete(photo)
            }
            try? context.save()
            isDEleting = false
        }
        
        
        API.getPhotosUrl(with: pin.coordinate , pageNum: pageNum ) { ( urls , errorMessage ) in DispatchQueue.main.async {
                
                self.updateUI(processing: false)
                guard errorMessage == nil else {
                    MapViewController.showeAlert(viewController: self, title: "Ther is an error to fetch Photo ", message: errorMessage! )
                    return }
                
                guard let urls = urls , !urls.isEmpty else {
                    self.message.isHidden = false
                    return
                }
                
                for url in urls {
                    let photo = Photo(context: self.context)
                    photo.imageURL = url
                    photo.pin = self.pin
                    print(url)
                }
                
                try? self.context.save()
            }
        }
        
        self.pageNum += 1
        
    }
    
    
    func setupFetchedResult () {
        
        let fetchRequest : NSFetchRequest<Photo> = Photo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "pin == %@ ", pin)
        let creationDate = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [ creationDate ]
        fetchedResultControllor = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultControllor.delegate = self
       
        
        do {
            try fetchedResultControllor.performFetch()
            if  havePhotos {
                updateUI(processing: false)
            }
            else {
                newCollectionTapped(self)
            }
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    
  
    
    // MARK: Collection View
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultControllor.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! photoCell
        let photo = fetchedResultControllor.object(at: indexPath)
        cell.imageView.setPhoto(photo)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
       let photo = fetchedResultControllor.object(at: indexPath)
        context.delete(photo)
        try? context.save()
    }
    
    // MARK: Collection View Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    

    //MarK : NSFetchedResultsController
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        collectionView.reloadData()
        
        if let indexPath = indexPath , type == .delete && !isDEleting {
            collectionView.deleteItems(at: [indexPath])
            return
        }
        
        if let newIndexPath = newIndexPath , let oldIndexPath = indexPath , type == .move {
            collectionView.moveItem(at: oldIndexPath, to: newIndexPath)
            return
        }
        
        if type == .update {
            collectionView.reloadData()
            
        }
    }
}
