//
//  MapPin.swift
//  LukesPeoplemonGo
//
//  Created by Lucas Lell on 11/10/16.
//  Copyright © 2016 Luuke192. All rights reserved.
//

import UIKit
import MapKit


class MapPin: NSObject, MKAnnotation {
    var coordinate:CLLocationCoordinate2D
    var person: Person?
    var userName: String?
    var userId: String?
    var title: String?
    
    
    init(person: Person){
        self.person = person
        self.title = person.userName
        self.userId = person.userId
        if let lat = person.latitude, let long = person.longitude{
            self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
        }else {
            self.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
    }
}
