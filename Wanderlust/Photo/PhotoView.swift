//
//  PhotoView.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/13/23.
//

import SwiftUI

class PhotoViewModel: ObservableObject {
    var selectedTrip: Trip?
    @Published var photos: [Photo] = []
    
    func fetchPhotos() {
        guard let fetch = selectedTrip?.photo as? Set<Photo> else {
            print("Could not fetch photos for the trip")
            return
        }
        self.photos = Array(fetch)
    }
}
struct PhotoView: View {
    let selectedTrip: Trip?
    @StateObject private var viewModel = PhotoViewModel()
    @State private var isAddPhotoView = false

    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 10) {
                ForEach(viewModel.photos, id: \.self) { photo in
                    VStack {
                        CustomCoverPhoto(coverPhoto: fileManagerClassInstance.loadImageFromFileManager(relativePath: photo.imageData ?? ""))
                            .onTapGesture {
                                print(photo.photoCaption!)
                            }
                        Text(photo.photoCaption ?? "")
                            .font(.caption)
                            .foregroundColor(.primary)
                        Text(photo.photoTag ?? "")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(15)
        }
        .navigationTitle("Gallery")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isAddPhotoView = true
                }) {
                    Label("Add Photo", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $isAddPhotoView) {
            AddPhotoView(selectedTrip: selectedTrip, viewModel: viewModel)
        }
        .onAppear {
            viewModel.selectedTrip = selectedTrip
            viewModel.fetchPhotos()
        }
    }
}

#Preview {
    PhotoView(selectedTrip: Trip())
}
