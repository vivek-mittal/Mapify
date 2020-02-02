//
//  AddLocationMapViewController.swift
//  Mapify
//
//  Created by Vivek on 31/01/20.
//  Copyright © 2020 Vivek. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddLocationMapViewController: UIViewController {

    var address: String? = nil
    var link: String? = nil
    var coordinate: CLLocationCoordinate2D? = nil
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        geocodeAddressString()
    }
    
    func geocodeAddressString() {
        self.mapView.isHidden = true
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address!) { [weak self] (placemarks, error) in
            if let placemark = placemarks?.first, let location = placemark.location {
                let mark = MKPlacemark(placemark: placemark)
                if var region = self?.mapView.region {
                    region.center = location.coordinate
                    self?.coordinate = location.coordinate
                    region.span.longitudeDelta /= 8.0
                    region.span.latitudeDelta /= 8.0
                    self?.mapView.setRegion(region, animated: true)
                    self?.mapView.addAnnotation(mark)
                }
                self?.mapView.isHidden = false
            } else {
                AlertUtil.showAlert(message: "Location not found", onViewController: self!)
            }
            self?.activityIndicator.stopAnimating()
        }
    }

    @IBAction func finishButtonTapped(_ sender: UIView) {
        if self.coordinate == nil {
            return
        }
        
        NetworkManager.shared.addLocation(address: address!, url: link!, latitude: self.coordinate!.latitude, longitude: self.coordinate!.longitude) { (error) in
            DispatchQueue.main.async(execute: {
                if error == nil {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.navigationController?.popViewController(animated: true)
                    AlertUtil.showAlert(message: (error)!.rawValue, onViewController: self.navigationController!)
                }
            })
        }
    }
}
