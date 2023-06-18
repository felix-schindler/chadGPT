//
//  ChatSettingsView.swift
//  ChadGPT
//
//  Created by Felix Schindler on 17.05.23.
//

import SwiftUI

struct ChatSettingsView: View {
    @Environment(\.presentationMode)
    private var presentationMode: Binding<PresentationMode>
    
    var callback: () -> Void
    @Binding var name: String
    @State var personality: ChadStyle = ChadModel.shared.settings.style
    
    /// Dismiss (close) this view
    private func dismiss() -> Void {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack {
                        HStack {
                            Text("You're chatting with")
                            TextField("Name", text: $name)
                        }
                        Picker("Personality", selection: $personality) {
                            ForEach(ChadStyle.allCases, id: \.self) { style in
                                Text(String(describing: style)).tag(style)
                            }
                        }
                    }
                }.toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button(role: .cancel, action: {
                            self.dismiss()
                        }, label: {
                            Label("Cancel", systemImage: "xmark.app.fill")
                                .labelStyle(.titleAndIcon)
                        }).foregroundStyle(.red)
                    }
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(action: {
                            ChadModel.shared.settings = ChadSettings(style: personality, name: name)
                            callback()
                            self.dismiss()
                        }, label: {
                            Label("Save", systemImage: "checkmark.circle")
                                .labelStyle(.titleAndIcon)
                        })
                    }
                }.navigationTitle("Settings")
            }
        }
    }
    
    
    struct ChatSettingsView_Previews: PreviewProvider {
        static var previews: some View {
            ChatSettingsView(callback: DataManager.shared.clearChatHistory ,name: .constant("Cardi B"), personality: .cute)
        }
    }
}
