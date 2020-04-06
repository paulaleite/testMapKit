//
//  ViewController.swift
//  MapKitTest
//
//  Created by Paula Leite on 06/04/20.
//  Copyright © 2020 Paula Leite. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    var points = [CLLocationCoordinate2D]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        requestUserAuthorization()
        
        showUserLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showUserLocation() {
        mapView.showsUserLocation = !mapView.isUserLocationVisible
    }
    
    func requestUserAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    func centerMap() {
        
        if let location = locationManager.location {
            var region = MKCoordinateRegion()
            region.center.latitude = location.coordinate.latitude
            region.center.longitude = location.coordinate.longitude
            region.span.longitudeDelta = 0.005
            
            mapView.region = region
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.denied {
            print("Autorize a localização para usar o App")
        } else if status == CLAuthorizationStatus.authorizedWhenInUse {
            print("Autorizado!")
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            
            if let touch = touches.first {
                let position :CGPoint = touch.location(in: view)
                let coord = mapView.convert(position, toCoordinateFrom: self.view)
                points.append(coord)

                // Annotation added
                let ann = MKPointAnnotation()
                ann.coordinate = coord
                ann.title = "Meu Pin"
                mapView.addAnnotation(ann)
            }
        }
        
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "Pin"

            if !(annotation is MKUserLocation) {
            
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                
                if annotationView == nil {
                    annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    annotationView?.canShowCallout = true

                    let btn = UIButton(type: .detailDisclosure)
                    annotationView!.rightCalloutAccessoryView = btn
                } else {
                    annotationView!.annotation = annotation
                }
                
                return annotationView
            }
            
            return nil
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            let ac = UIAlertController(title: "Aviso", message: "Você tocou no Pin!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }

}

