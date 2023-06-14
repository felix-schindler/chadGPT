//
//  ContentView.swift
//  ChadGPT
//
//  Created by Felix Schindler on 17.05.23.
//

import SwiftUI

struct GeneratorView: View {
    /// User input
    @State var userInput = ""
    /// Pick up lines
    @State var lines: [String]? = []
    /// Whether there are lines being generated right now
    @State var loading = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("She's a 10 but...", text: $userInput)
                    if (loading) {
                        ProgressView()
                    } else {
                        Button(action: {
                            Task {
                                loading = true
                                // TODO: Add API call
                                lines = [
                                    "Excuse me, are you a dictionary? Because you add meaning to my otherwise dumm life.",
                                    "Are you a math equation? Because you're the missing variable in my dumm love life."
                                ]
                                loading = false
                            }
                        }, label: {
                            Text("Generate")
                        })
                    }
                }
                
                if (lines != nil && !(lines!.isEmpty)) {
                    Section("Pickup lines") {
                        ForEach(lines!, id: \.self) { line in
                            Text(line)
                                .swipeActions {
                                    Button(action: {
                                        // TODO: Add to starred
                                    }, label: {
                                        Label("Add to starred", systemImage: "star")
                                    }).tint(.yellow)
                                }
                        }
                    }.transition(.slide) // FIXME: This somehow doesn't works
                }
            }
        }.navigationTitle("Generator")
    }
}

struct Generator_Previews: PreviewProvider {
    static var previews: some View {
        GeneratorView()
    }
}
