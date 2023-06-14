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
    @State var lines: [String] = []
    /// Whether there are lines being generated right now
    @State var loading = false
    
    @ObservedObject var dataManager = DataManager.shared
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("She's a 10 but...", text: $userInput)
                    if (loading) {
                        ProgressView()
                    } else {
                        Button("Generate") {
                            Task {
                                await generatePickUpLine()
                            }
                        }
                    }
                }
                
                if (!lines.isEmpty) {
                    Section("Pickup lines") {
                        ForEach(lines, id: \.self) { line in
                            Text(line)
                                .swipeActions {
                                    Button(
                                        role: .destructive,
                                        action: {
                                            // TODO: Remove from lines array
                                            if let index = lines.firstIndex(of: line) {
                                                lines.remove(at: index)
                                            }
                                        },
                                        label: {
                                            Label("Remove", systemImage: "trash")
                                        }
                                    ).tint(.red)
                                }.swipeActions(edge: .leading) {
                                    Button(action: {
                                        dataManager.savePickUpLine(line: line)
                                    }, label: {
                                        Label("Add to starred", systemImage: "star")
                                    }).tint(.yellow)
                                }.textSelection(.enabled)
                        }
                    }.transition(.slide) // FIXME: This somehow doesn't works
                }
            }.navigationTitle("Generator")
                .scrollDismissesKeyboard(.interactively)
        }
    }
    
    private func generatePickUpLine() async -> Void {
        do {
            loading = true
            let res = try await ChadModel.shared.makeAPIRequest(self.userInput, systemMessage: ChadStyle.flirty.rawValue)
            res.choices.forEach { lines.insert($0.message.content, at: 0) }
            loading = false
        } catch {
            // Handle API call error
            print("[ERROR] This happened during the API call: \(error)")
        }
    }
}

struct Generator_Previews: PreviewProvider {
    static var previews: some View {
        GeneratorView()
    }
}
