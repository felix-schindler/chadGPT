//
//  ChadGPTApp.swift
//  ChadGPT
//
//  Created by Felix Schindler on 17.05.23.
//

import SwiftUI

@main
struct ChadGPTApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                GeneratorView()
                    .tabItem {
                        Label("Generator", systemImage: "lightbulb")
                    }.tag(0)
                ChatView()
                    .tabItem {
                        Label("Chat", systemImage: "bubble.left.and.bubble.right")
                    }.tag(1)
                StarredView()
                    .tabItem {
                        Label("Starred", systemImage: "star")
                    }.tag(2)
            }
        }
    }
}
