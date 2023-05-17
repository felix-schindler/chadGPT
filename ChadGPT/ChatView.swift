//
//  ChatView.swift
//  ChadGPT
//
//  Created by Felix Schindler on 17.05.23.
//

import SwiftUI

enum Sender {
    case bot,
         human
}

struct Message: Hashable {
    let sender: Sender
    let content: String
    
    func hash(into hasher: inout Hasher) {
        return self.content.hash(into: &hasher)
    }
}

struct ChatView: View {
    @State var name = "Cardi B"
    @State var messages: [Message] = [
        Message(sender: .human, content: "Hi"),
        Message(sender: .bot, content: "Hello, yourself."),
        Message(sender: .human, content: "Thank you"),
        Message(sender: .bot, content: "No problem"),
        Message(sender: .human, content: "Write a longer text"),
        Message(sender: .bot, content: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."),
        Message(sender: .human, content: "F"),
        Message(sender: .bot, content: "F"),
        Message(sender: .human, content: "F"),
        Message(sender: .bot, content: "F"),
        Message(sender: .human, content: "F"),
        Message(sender: .bot, content: "F"),
    ]
    
    @State var msg = ""
    
    @State var showSettings = false
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    MessageListView(messages: $messages)
                }
                Spacer()
                HStack {
                    TextField("Message", text: $msg)
                        .textFieldStyle(.roundedBorder)
                        .scrollDismissesKeyboard(.immediately)
                    Button(action: {
                        if (!msg.isEmpty) {
                            // TODO: Send message
                            messages.append(Message(sender: .human, content: msg))
                            msg = ""
                        }
                    }, label: {
                        Label("Send", systemImage: "paperplane")
                            .labelStyle(.iconOnly)
                    })
                }
            }.toolbar {
                Button(action: { showSettings = true }, label: {
                    Label("Settings", systemImage: "gearshape")
                })
            }.sheet(isPresented: $showSettings, content: { ChatSettingsView(name: $name, show: $showSettings) })
                .padding(.horizontal)
                .navigationTitle("Chat with \(name)")
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
