//
//  Location.swift
//  BucketList
//
//  Created by Brian Vo on 5/16/24.
//

import Foundation
import MapKit

struct Location : Codable, Equatable, Identifiable{
    var id: UUID
    var name: String
    var description : String
    var latitude : Double
    var longitude : Double
    
    
    var coordinate : CLLocationCoordinate2D{
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    static func ==(lhs: Location, rhs: Location) -> Bool{
        
        lhs.id == rhs.id
        
    }
    
    #if DEBUG
    static let example = Location(id: UUID(), name: "Tysons Corner", description: "Only place at nova", latitude: 38.917130, longitude: -77.222237)
    #endif
    
}
