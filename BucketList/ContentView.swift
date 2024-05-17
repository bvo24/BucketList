//
//  ContentView.swift
//  BucketList
//
//  Created by Brian Vo on 5/16/24.
//
import MapKit
import SwiftUI

struct ContentView: View {
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 38.8051, longitude: -77.0470),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
    
        )
    )

    @State private var viewModel = ViewModel()
    
    var body: some View {
        
        if viewModel.isUnlocked{
            MapReader{ proxy in
                
                
                Map(initialPosition: startPosition){
                    ForEach(viewModel.locations){ location in
                        Annotation(location.name, coordinate: location.coordinate){
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundStyle(.red)
                                .frame(width:44, height:44)
                                .background(.white)
                                .clipShape(.circle)
                                .onLongPressGesture{
                                    viewModel.selectedPlace = location
                                }
                        }
                        
                    }
                }
                .onTapGesture { position in
                    
                    if let coordinate = proxy.convert(position, from: .local){
                        viewModel.addLocation(at: coordinate )
                    }
                    
                    
                    
                }
                .sheet(item: $viewModel.selectedPlace){ place in
                    EditView(location: place){ newLocation in
                        
                        viewModel.update(location: newLocation)
                    }
                    
                }
            }
        }
        else{
            //Button
            Button("Unlock Places", action: viewModel.authenticate)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.capsule)
            
            
        }
    }
}

#Preview {
    ContentView()
}
