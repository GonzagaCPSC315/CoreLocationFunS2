//
//  ViewController.swift
//  CoreLocationFunS2
//
//  Created by Gina Sprint on 11/18/20.
//

import UIKit
import CoreLocation

// MARK: - Location Services
// Simulator -> Features -> Location and choose a custom location or a predefined location/route
// CLLocationManager: a class that is used to get the user's location and updates
// CLGeocoder: a class that is used to convert address/place -> coordinates and coordinates -> address/place
// task: set up a UI with three labels: latitude, longitude, name
// set up the outlets

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var longitudeLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // first is see if location services are enabled
        if CLLocationManager.locationServicesEnabled() {
            print("enabled")
            setupLocationServices()
        }
        else {
            print("disabled")
            // the user has turned off location services, airplane mode, HW failure, etc.
        }
    }

    func setupLocationServices() {
        // need a CLLocationManager object
        // and we need a delegate object
        locationManager.delegate = self
        
        // we need to get the user's permission (AKA authorization) to access their location
        // two types of authorization for location
        // 1. When in use: the app gets location updates when its running
        // 2. Always: the app always gets location updates. the OS will start the app to deliver an updates
        // we will do 1.
        // we need to add a key-value pair to Info.plist to declare the location services dependency and get permission
        // key: Privacy - Location When in Use Usage Description
        // value: a description of why your app needs this access
        locationManager.requestWhenInUseAuthorization()
        
        // by default the location desired accuracy is "best"
        // you should choose the most course-grained accuracy that your app can tolerate
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        // two types of location updates
        // 1. requestLocation(): one time update of the location
        // 2. startUpdatingLocation(): continuous updates of the user's location
        // don't forget to call stopUpdatingLocation() when you're done with location
        //locationManager.requestLocation()
        // need delegate callback methods!!
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        // update the labels!
        // we are guaranteed there is at least one location
        // the newest updates are at the end of the array
        let location = locations[locations.count - 1]
        latitudeLabel.text = "Latitude: \(location.coordinate.latitude)"
        longitudeLabel.text = "Longitude: \(location.coordinate.longitude)"
        // we need a geocoder to get name
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placeMarksOptional, errorOptional) in
            if let placeMarks = placeMarksOptional, placeMarks.count > 0 {
                let placeMark = placeMarks[0]
                if let name = placeMark.name {
                    self.nameLabel.text = "Name: \(name)"
                }
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error requesting location \(error)")
        // a few notable error codes
        // 0: there is no location (e.g. Simulator location is None)
        // 1: access denied
    }
}

