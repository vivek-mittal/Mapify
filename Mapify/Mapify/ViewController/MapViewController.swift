//
//  MapViewController.swift
//  Mapify
//
//  Created by Vivek on 30/01/20.
//  Copyright © 2020 Vivek. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var annotations: [MKPointAnnotation]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.loadMapData(forceRefresh: false) { (error) in
            DispatchQueue.main.async(execute: {
                if error == nil {
                    self.reloadData()
                }
            })
        }
    }
    
    func reloadData() {
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.annotations = [MKPointAnnotation]()
        for location in ModelManager.shared.studentLocations! {
            let point = MKPointAnnotation()
            point.title = location.getName()
            point.subtitle = location.mediaURL
            point.coordinate = location.getCoordinate()
            self.mapView.addAnnotation(point)
            self.annotations?.append(point)
        }
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        NetworkManager.shared.logout { (error) in
            DispatchQueue.main.async(execute: {
                if error == nil {
                    self.showLoginScreen()
                }
            })
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        NetworkManager.shared.loadMapData(forceRefresh: true) { (error) in
            DispatchQueue.main.async(execute: {
                if error == nil {
                    self.reloadData()
                }
            })
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let addLocation = self.storyboard!.instantiateViewController(withIdentifier: "add_location")
        self.present(addLocation, animated: true, completion: nil)
    }
    
    func showLoginScreen() {
        let sceneDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        sceneDelegate.showLoginScreen()
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotation_id")
        annotationView.canShowCallout = true
        let detail = UILabel()
        detail.text = annotation.subtitle!
        annotationView.detailCalloutAccessoryView = detail
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(MapViewController.calloutSelected(_:)))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func calloutSelected(_ sender: UITapGestureRecognizer) {
        guard let annotation = (sender.view as? MKAnnotationView)?.annotation as? MKPointAnnotation else { return }
        let index = self.annotations?.firstIndex(of: annotation)
        if index! >= 0 {
            let mediaUrl = ModelManager.shared.studentLocations![index!].mediaURL
            if let link = URL(string: mediaUrl ?? "") {
                UIApplication.shared.open(link)
            }
        }
    }
}
