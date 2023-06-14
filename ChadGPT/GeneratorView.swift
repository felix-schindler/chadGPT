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
    
    @ObservedObject var dataManager = DataManager.shared
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("She's a 10 but...", text: $userInput)
                    Button("Generate") {
                        lines = nil
                        // TODO: Add API call
                        Task {
                            await generatePickUpLine()
                        }
                        /*lines = [
                            "Excuse me, are you a dictionary? Because you add meaning to my otherwise dumm life.",
                            "Are you a math equation? Because you're the missing variable in my dumm love life."
                        ]*/
                    }
                }
                
                Section("Pick up lines") {
                    if (lines != nil) {
                        if (lines!.isEmpty) {
                            Text("Dir kann nicht mehr geholfen werden!")
                        } else {
                            ForEach(lines!, id: \.self) { line in
                                Text(line)
                                    .swipeActions {
                                        Button(action: {
                                            dataManager.savePickUpLine(line: line)
                                        }, label: {
                                            Label("Add to starred", systemImage: "star")
                                        }).tint(.yellow)
                                    }
                            }
                        }
                    } else {
                        ProgressView()
                    }
                }
            }.navigationTitle("Generator")
        }
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
