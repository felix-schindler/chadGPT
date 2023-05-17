//
//  ChatSettingsView.swift
//  ChadGPT
//
//  Created by Felix Schindler on 17.05.23.
//

import SwiftUI

struct ChatSettingsView: View {
    @Binding var name: String
    @Binding var show: Bool
    
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Text("You're chatting with")
                    TextField("Name", text: $name)
                }
                Button("Apply") {
                    // TODO: Show alert when name is empty
                    show = false
                }
            }.navigationTitle("Settings")
        }
    }
}

struct ChatSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatSettingsView(name: .constant(""), show: .constant(true))
    }
}
