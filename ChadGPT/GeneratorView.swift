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
                                await generatePickUpLine()
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
    
    private func generatePickUpLine() async -> Void {
        do {
            let res = try await ChadModel.shared.makeAPIRequest(self.userInput, systemMessage: ChadStyle.flirty.rawValue)
               lines = res.choices.map { $0.message.content }
           } catch {
               // Handle API call error
               print("API call error: \(error)")
           }
    }
}

struct Generator_Previews: PreviewProvider {
    static var previews: some View {
        GeneratorView()
    }
}
