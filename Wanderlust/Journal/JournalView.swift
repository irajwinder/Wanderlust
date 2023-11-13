//
//  JournalView.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/6/23.
//

import SwiftUI

class JournalViewModel: ObservableObject {
    func fetchJournals() {
        
    }
}

struct JournalView: View {
    let selectedTrip: Trip?
    @State private var isAddJournalView = false
    
    @StateObject private var viewModel = JournalViewModel()
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Journal.journalText, ascending: true)],
        animation: .default)
    private var journals: FetchedResults<Journal>

    var body: some View {
            List {
                ForEach(journals.filter { $0.trip?.tripName == selectedTrip?.tripName }, id: \.self) { journal in
                    NavigationLink(destination: PhotoView(selectedTrip: selectedTrip)) {
                        Text(journal.journalText ?? "")
                    }
                }.onDelete { indexSet in
                    for index in indexSet {
                        let journal = journals[index]
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
                    AddJournalView(viewModel: viewModel, selectedTrip: selectedTrip)
        }.onAppear(perform: {
            //On Appear
        })
    }
}

#Preview {
    JournalView(selectedTrip: Trip())
}
