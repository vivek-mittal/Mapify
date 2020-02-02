//
//  LocationResult.swift
//  Mapify
//
//  Created by Vivek on 30/01/20.
//  Copyright © 2020 Vivek. All rights reserved.
//

import Foundation
import MapKit

struct LocationResult: Codable {
    var results: [StudentInformation]?
    
    func hasLocationData() -> Bool {
        return results != nil && results!.count > 0
    }
}

struct StudentInformation: Codable {
    var firstName: String?
    var lastName: String?
    var longitude: Double?
    var latitude: Double?
    var mapString: String?
    var mediaURL: String?
    var uniqueKey: String?
    var objectId: String?
    var createdAt: String?
    var updatedAt: String?
}

extension StudentInformation  {
    func getName() -> String {
        return "\((self.firstName)!) \((self.lastName)!)"
    }
    
    func getCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
    }
}
