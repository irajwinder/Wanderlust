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
    @State private var isAddPhotoView = false
    @StateObject private var viewModel = PhotoViewModel()

    var body: some View {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 10) {
                    ForEach(viewModel.photos, id: \.self) { photo in
                        VStack {
                            CustomCoverPhoto(coverPhoto: loadPhoto(photos: photo))
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
                AddPhotoView(viewModel: viewModel, selectedTrip: selectedTrip)
            }
            .onAppear {
                viewModel.selectedTrip = selectedTrip
                viewModel.fetchPhotos()
            }
    }
    
    func loadPhoto(photos: Photo) -> UIImage {
        guard let photoRelativePath = photos.imageData else {
            print("Photos has no cover photo path")
            return UIImage(systemName: "person") ?? UIImage()
        }
        
        // Construct the local file URL by appending the relative path to the documents directory
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let localFileURL = documentsDirectory.appendingPathComponent(photoRelativePath)
        
        do {
            // Read image data from the local file
            let imageData = try Data(contentsOf: localFileURL)
            if let uiImage = UIImage(data: imageData) {
                return uiImage
            } else {
                print("Failed to create UIImage from data")
                return UIImage(systemName: "person") ?? UIImage()
            }
        } catch {
            print("Error loading image:", error.localizedDescription)
            return UIImage(systemName: "person") ?? UIImage()
        }
    }
}

//struct PhotoView: View {
//    let selectedTrip: Trip?
//    @State private var isAddPhotoView = false
//    @State private var galleryPicture: UIImage?
//    @StateObject private var viewModel = PhotoViewModel()
//    
//    var body: some View {
//        List {
//            ForEach(viewModel.photos, id: \.self) { photo in
//                    CustomCoverPhoto(coverPhoto: galleryPicture)
//                    VStack(alignment: .leading) {
//                        Text(photo.photoCaption ?? "")
//                            .font(.headline)
//                        Text(photo.photoTag ?? "")
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                    }
//            }.onDelete { indexSet in
//                for index in indexSet {
//                    let photo = viewModel.photos[index]
//                    DataManager.sharedInstance.deleteEntity(photo)
//                }
//            }
//        }.navigationTitle("Gallery")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: {
//                        isAddPhotoView = true
//                    }) {
//                        Label("Save", systemImage: "plus")
//                    }
//                }
//            }.sheet(isPresented: $isAddPhotoView) {
//                AddPhotoView(viewModel: viewModel, selectedTrip: selectedTrip)
//            }.onAppear(perform: {
//                viewModel.selectedTrip = selectedTrip
//                viewModel.fetchPhotos()
//            })
//    }
//}

#Preview {
    PhotoView(selectedTrip: Trip())
}
