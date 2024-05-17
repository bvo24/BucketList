//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Brian Vo on 5/17/24.
//
import CoreLocation
import Foundation
import LocalAuthentication
import MapKit
import _MapKit_SwiftUI


extension ContentView{
    @Observable
    class ViewModel{
        private(set) var locations : [Location]
        var selectedPlace : Location?
        var isUnlocked = false
        let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")
        var mapHybrid = false
        var alertShown = false
        var alertMessage = ""
        var alertTitle = "Error"
        
        init(){
            do{
                let data = try Data(contentsOf: savePath)
                locations =  try JSONDecoder().decode([Location].self, from: data)
                
                
            }catch{
                locations = []
            }
        }
        
        var isHybrid : MapStyle{
            guard mapHybrid else{
                return .hybrid
            }
            return .standard
            
        }
        
        
        func save(){
            do{
                let data = try JSONEncoder().encode(locations)
                try data.write(to:savePath, options: [.atomic, .completeFileProtection])
                
            }catch{
                print("Unable to save data")
            }
            
            
        }
        
        func addLocation(at point: CLLocationCoordinate2D){
            let newLocation = Location(id: UUID(), name: "New Location", description: "", latitude: point.latitude, longitude: point.longitude)
            locations.append(newLocation)
            save()
            
        }
        
        func update(location: Location){
            
            guard let selectedPlace else {return}
            if let index = locations.firstIndex(of: selectedPlace){
                locations[index] = location
                save()
            }
            
            
        }
        
        func authenticate() async{
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
                let reason = "Please authenticate yourself to unlock your places"
                do {
                       let success = try await  context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
                       if success {
                           self.isUnlocked = true
                       }
                } catch( let error) {
                       alertMessage = error.localizedDescription
                       alertShown.toggle()
                   }
                
//                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){
//                    success, authenticationError in
//                    
//                        if success{
//                            self.isUnlocked = true
//                        }
//                    
//                    
//                    else{
//                     //error
//                        if let error = error{
//                            print("Face id error")
//                            self.alertMessage = error.localizedDescription
//                            self.alertShown = true
//                            
//                            
//                        }
//                        
//                        
//                    }
//                    
//                    
//                    
//                }
                
            }
            else{
                //No biometrics
                if let error = error{
                    print("Face id error")
                    self.alertMessage = error.localizedDescription
                    self.alertShown = true


                }
                
                
                
                
            }
                
            
            
        }
        
        
    }
}
