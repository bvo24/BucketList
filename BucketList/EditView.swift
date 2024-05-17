//
//  EditView.swift
//  BucketList
//
//  Created by Brian Vo on 5/16/24.
//

import SwiftUI

struct EditView: View {
    
    
    
    @Environment(\.dismiss) var dismiss
    
    @State private var viewModel : ViewModel
    
    var onSave : (Location) -> Void
    
    
    
    
    
    var body: some View {
        NavigationStack{
            Form{
                Section{
                    TextField("Place name", text:$viewModel.name)
                    TextField("Description", text:$viewModel.description)
                    
                }
                
                
                Section("Near by"){
                    switch viewModel.loadingState{
                    case .loading:
                        Text("Loading")
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid){page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ") +
                            Text(page.description)
                                .italic()
                            
                            
                            
                        }
                    case .failed:
                        Text("Try again later")
                        
                        
                        
                    }
                    
                    
                }
                
            }
            .navigationTitle("Place details")
            .toolbar{
                Button("Save"){
                    //Creates a new location
                    let newLocation = viewModel.save()
                    //Our function passed here was update so we change our edited location to our new one
                    onSave(newLocation)
                    dismiss()
                }
            }
            .task{
                await viewModel.fetchNearbyPlaces()
            }
            
            
            
            
        }
    }
    
    
    
    init(location : Location, onSave: @escaping (Location) -> Void ){
        self.onSave = onSave
        _viewModel = State(initialValue: ViewModel(location: location ))
        
        
    }
    
    
}

#Preview {
    EditView(location: .example){_ in }
}
