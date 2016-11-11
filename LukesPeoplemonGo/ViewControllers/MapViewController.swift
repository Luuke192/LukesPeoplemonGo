//
//  MapViewController.swift
//  LukesPeoplemonGo
//
//  Created by Lucas Lell on 11/8/16.
//  Copyright © 2016 Luuke192. All rights reserved.
//

import Foundation
import MapKit
import Alamofire
import MBProgressHUD
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    let locationManager = CLLocationManager()
    var updateLocation = true
    var latitudeDelta = 0.002
    var longitudeDelta = 0.002
    var annotations: [MapPin] = []
    var overlay: MKOverlay?
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        
        // Do any additional setup after loading the view.
        self.locationManager.delegate = self
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            self.mapView.showsUserLocation = true
            self.locationManager.startUpdatingLocation()
            
            
        }else{
            self.locationManager.requestWhenInUseAuthorization()
        }
        mapView.mapType = MKMapType.hybrid
        loadMap()
    }
    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        let myArea = MKCoordinateRegionMakeWithDistance(self.locationManager.location!.coordinate, 500, 500)
        self.mapView.setRegion(myArea, animated: true)
        updateLocation = false
        locationManager.stopUpdatingLocation()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !WebServices.shared.userAuthTokenExists() || WebServices.shared.userAuthTokenExpired(){
            performSegue(withIdentifier: "PresentLoginNoAnimation", sender: self)
        }else{
            let user = User()
            WebServices.shared.getObject(user, completion: { (user2, _) in
                if let user2 = user2 {
                    UserStore.shared.user = user2
                }
            })
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopTimer()
    }
    
    func loadMap(){
        if let coordinate = locationManager.location?.coordinate {
            let checkIn = Person(longitude: coordinate.longitude, latitude: coordinate.latitude)
            WebServices.shared.postObject(checkIn, completion: { (object, error) in
            })
            
            
        }
        let peopleNearby = Person(radius: 100)
        WebServices.shared.getObjects(peopleNearby){
            (nearbyPeople, error) in
            if let nearbyPeople = nearbyPeople{
                let otherAnnotations = self.annotations
                self.annotations = []
                for person in nearbyPeople {
                    let pin = MapPin(person: person)
                    self.annotations.append(pin)
                }
                self.mapView.addAnnotations(self.annotations)
                self.mapView.removeAnnotations(otherAnnotations)
            }
        }
    }
    func beginTimer(){
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(loadMap), userInfo: nil, repeats: true)
    }
    func stopTimer(){
        timer?.invalidate()
        timer = nil
    }
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width, height: size.height)
        } else {
            newSize = CGSize(width: size.width, height: size.height)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    //Mark - @IBActions
    @IBAction func logout(_ sender: Any) {
        UserStore.shared.logout{
            self.performSegue(withIdentifier: "PresentLogin", sender: self)
        }
    }
    
    @IBAction func CheckIn(_ sender: AnyObject) {
        //get the location
        loadMap()
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            //look up User
            if let mapPin = annotation as? MapPin{
                if let image = Utils.stringToImage(str: mapPin.person?.avatarBase64) {
                    let resizedImage = Utils.resizeImage(image: image, maxSize: 30)
                    pinView?.image = resizedImage
                    pinView?.contentMode = .scaleToFill
                    pinView?.clipsToBounds = false
                    pinView?.layer.borderWidth = 2
                    pinView?.layer.borderColor = UIColor(red: 0, green: 0, blue: 1, alpha: 1).cgColor
                } else {
                    pinView?.image = nil
                }
            }
        }
        return pinView
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let mapPin = view.annotation as? MapPin, let people = mapPin.person, let name = people.userName, let userId = people.userId {
            let alert = UIAlertController(title: "Catch User", message: "Catch \(name)?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Catch", style: .default, handler: { (action) in
                let catchPeople = Person(caughtUserId: userId, radius: Constants.radius)
                WebServices.shared.postObject(catchPeople, completion: { (object, error) in
                    if let error = error{
                        self.present(Utils.createAlert(message: error), animated: true, completion: nil)
                    } else{
                        self.present(Utils.createAlert("Nice!", message: "You caught \(name)!"), animated: true, completion: nil)
                    }
                })
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        self.overlay = overlay
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.green
        renderer.lineWidth = 5.0
        renderer.lineCap = CGLineCap.round
        return renderer
    }
}
