//
//  ContentView.swift
//  OvercastDrawer
//
//  Created by Ryan Lintott on 2022-07-16.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Playlist()
                
                OvercastPlayer(size: proxy.size)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
