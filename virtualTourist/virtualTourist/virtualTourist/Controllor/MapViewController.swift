//
//  ViewController.swift
//  virtualTourist
//
//  Created by Manal  harbi on 28/03/1441 AH.
//  Copyright © 1441 Udasity. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController , MKMapViewDelegate , NSFetchedResultsControllerDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    
    var fetchedResultControllor : NSFetchedResultsController<Pin>!
    
    var context : NSManagedObjectContext {
        return DataControllor.shared.viewContext
    }
    
    @IBAction func LongPress(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state != .began { return }
        let touchPoint = sender.location(in: mapView)
        
        let pin = Pin(context: context)
        pin.coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        try? context.save()
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchRequest()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fetchedResultControllor = nil
    }

    
    func setupFetchRequest () {
        
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        let creationDate = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [ creationDate ]
        fetchedResultControllor = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultControllor.delegate = self as NSFetchedResultsControllerDelegate
        do {
           try fetchedResultControllor.performFetch()
            updateMapView()
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    
    
    
    func updateMapView() {
        
        guard let pins = fetchedResultControllor.fetchedObjects else { return }
        for pin in pins {
            if mapView.annotations.contains(where:  { pin.compare(to: $0.coordinate ) } ) { continue }
            let annotation = MKPointAnnotation()
            annotation.coordinate = pin.coordinate
            mapView.addAnnotation(annotation)
        }
        
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let pin = fetchedResultControllor.fetchedObjects?.filter { $0.compare (to: view.annotation!.coordinate) }.first
        performSegue(withIdentifier: "photosVC", sender: pin)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photosVC" {
            let photosVC = segue.destination as! PhotoAlbumVC
            photosVC.pin = sender as? Pin
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateMapView()
    }
    
    
    static func showeAlert(viewController: UIViewController, title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    
}

