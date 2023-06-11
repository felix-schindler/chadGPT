//
//  ChatView.swift
//  ChadGPT
//
//  Created by Felix Schindler on 17.05.23.
//

import SwiftUI

struct ChatView: View {
    @State var name = "Cardi B"
    @State var messages: [Message] = [] // TODO: Load old messages / history (?)
    
    @State var msg = ""
    
    @State var showSettings = false
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    if (messages.isEmpty) {
                        Spacer()
                        Label("As soon as you write messages, they will appear here", systemImage: "bubble.left.and.exclamationmark.bubble.right")
                        Spacer()
                    } else {
                        MessageListView(messages: $messages)
                    }
                }
                Spacer()
                HStack {
                    TextField("Message", text: $msg)
                        .textFieldStyle(.roundedBorder)
                        .scrollDismissesKeyboard(.immediately)
                    Button(action: {
                        if (!msg.isEmpty) {
                            // TODO: Send message
                            Task {
                                do {
                                    let msg = self.msg; self.msg = ""
                                    self.messages.append(Message(role: "user", content: msg))
                                    let res  = try await ChadModel.shared.makeAPIRequest(systemMessage: ChadModel.CUTE, prompt: msg)
                                    let msgs = res.choices.map { $0.message }
                                    let _    = msgs.map { self.messages.append($0) }
                                } catch {
                                    print("[ERROR] Failed to send message", error)
                                }
                            }
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
        ChatView(messages: [
            Message(role: "user", content: "Hi"),
            Message(role: "assistant", content: "Hello, yourself."),
            Message(role: "user", content: "Thank you"),
            Message(role: "assistant", content: "No problem"),
            Message(role: "user", content: "Write a longer text"),
            Message(role: "assistant", content: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."),
            Message(role: "user", content: "F"),
            Message(role: "assistant", content: "F"),
            Message(role: "user", content: "F"),
            Message(role: "assistant", content: "F"),
            Message(role: "user", content: "F"),
            Message(role: "assistant", content: "F"),
        ])
    }
}
