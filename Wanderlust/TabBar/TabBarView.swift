//
//  TabBarView.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/6/23.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            TripView()
                .tabItem {
                    Label("Trip", systemImage: "airplane")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}

#Preview {
    TabBarView()
}
