//
//  JournalView.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/6/23.
//

import SwiftUI

class JournalViewModel: ObservableObject {
    var selectedTrip: Trip?
    @Published var journals: [Journal] = []
    
    func fetchJournals() {
        guard let fetch = selectedTrip?.journal as? Set<Journal> else {
            print("Could not fetch journals for the trip")
            return
        }
        self.journals = Array(fetch)
    }
}

struct JournalView: View {
    let selectedTrip: Trip?
    @StateObject private var viewModel = JournalViewModel()
    @State private var isAddJournalView = false
    
    var body: some View {
            List {
                ForEach(viewModel.journals, id: \.self) { journal in
                    NavigationLink(destination: PhotoView(selectedTrip: selectedTrip)) {
                        CustomCoverPhoto(coverPhoto: fileManagerClassInstance.loadImageFromFileManager(relativePath: journal.journalEntryPhoto ?? ""))
                        VStack(alignment: .leading) {
                            Text(journal.journalEntryText ?? "")
                                .font(.headline)
                            Text("\(Validation.dateToString(journal.journalEntryDate))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(journal.photoLongitude), \(journal.photoLatitude)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }.onDelete { indexSet in
                    for index in indexSet {
                        let journal = viewModel.journals[index]
                        DataManager.sharedInstance.deleteEntity(journal)
                    }
                }
            }.navigationTitle("Journals")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            isAddJournalView = true
                        }) {
                            Label("Save", systemImage: "plus")
                        }
                    }
                }.sheet(isPresented: $isAddJournalView) {
                    AddJournalView(selectedTrip: selectedTrip, viewModel: viewModel)
        }.onAppear(perform: {
            viewModel.selectedTrip = selectedTrip
            viewModel.fetchJournals()
        })
    }
}

#Preview {
    JournalView(selectedTrip: Trip())
}
