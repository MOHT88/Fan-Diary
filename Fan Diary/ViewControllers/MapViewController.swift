//
//  MapViewController.swift
//  Fan Diary
//
//  Created by Сергей Иванов on 01.09.2022.
//

import UIKit
import MapKit
import CoreLocation

protocol MapViewControllerDelegate {
    func getAddress(_ address: String?)
}

class MapViewController: UIViewController {
    
    let mapManager = MapManager()
    var mapViewControllerDelegate: MapViewControllerDelegate?
    var club = Club()
    let annotationIdentifier = "annotationIdentifier"
    var incomeSegueID = ""
    
    var previousLocation: CLLocation? {
        didSet {
            mapManager.startTrackingUserLocation(
                for: mapView,
                and: previousLocation) { (currentLocation) in
                    
                    self.previousLocation = currentLocation
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.mapManager.showUserLocation(mapView: self.mapView)
                    }
                }
        }
    }
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var mapPin: UIImageView!
    @IBOutlet var currentAddressLabel: UILabel!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var goButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentAddressLabel.text = ""
        mapView.delegate = self
        setupMapView()
    }
    
    @IBAction func centerViewInUserLocation() {
        mapManager.showUserLocation(mapView: mapView)
    }
    
    @IBAction func doneButtonPressed() {
        mapViewControllerDelegate?.getAddress(currentAddressLabel.text)
        dismiss(animated: true)
    }
    
    @IBAction func goButtonPressed() {
        mapManager.getDirection(for: mapView) { (location) in
            self.previousLocation = location
        }
    }
    
    @IBAction func closeVC() {
        dismiss(animated: true)
    }
    
    private func setupMapView() {
        
        goButton.isHidden = true
        
        mapManager.checkLocationServices(mapView: mapView, segueID: incomeSegueID) {
            mapManager.locationManager.delegate = self
        }
        
        if incomeSegueID == "showMap" {
            mapManager.setupPlacemark(club: club, mapView: mapView)
            mapPin.isHidden = true
            currentAddressLabel.isHidden = true
            doneButton.isHidden = true
            goButton.isHidden = false
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else { return  nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationIdentifier") as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation,
                                                 reuseIdentifier: annotationIdentifier)
            
            annotationView?.canShowCallout = true
        }
        
        if let imageData = club.imageData {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.image = UIImage(data: imageData)
            annotationView?.rightCalloutAccessoryView = imageView
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let center = mapManager.getCenterLocation(for: mapView)
        let geocoder = CLGeocoder()
        
        if incomeSegueID == "showMap" && previousLocation != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.mapManager.showUserLocation(mapView: self.mapView)
            }
        }
        
        geocoder.cancelGeocode()
        geocoder.reverseGeocodeLocation(center) { (placemarks, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarks = placemarks else { return }
            
            let placemark = placemarks.first
            let streetName = placemark?.thoroughfare
            let buildNumber = placemark?.subThoroughfare
            
            DispatchQueue.main.async {
                
                if streetName != nil && buildNumber != nil {
                    self.currentAddressLabel.text = "\(streetName!), \(buildNumber!)"
                }  else if streetName != nil {
                    self.currentAddressLabel.text = "\(streetName!)"
                } else {
                    self.currentAddressLabel.text = ""
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        
        return renderer
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        mapManager.checkLocationAuthorization(mapView: mapView, segueID: incomeSegueID)
    }
}
