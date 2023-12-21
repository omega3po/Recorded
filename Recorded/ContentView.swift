//
//  ContentView.swift
//  Recorded
//
//  Created by Sunny Hwang on 11/13/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            RecordView()
                .tabItem {
                    Image(systemName: "mic")
                }
            ListView()
                .tabItem {
                    Image(systemName: "list.dash")
                }
        }
        .accentColor(.white)
    }
}

#Preview {
    ContentView()
}
