//
//  ChatView.swift
//  ChadGPT
//
//  Created by Felix Schindler on 17.05.23.
//

import SwiftUI
import CoreData

struct ChatView: View {
    @State var name = ChadModel.shared.settings.name
    @State var messages: [Message] = [] // TODO: Load old messages / history (?)
    
    @State var loading = false
    @State var msg = ""
    
    @State var showSettings = false
    
    @ObservedObject var dataManager = DataManager.shared
    
    func loadChatHistory() {
        messages = dataManager.loadChatHistory().map { Message(role: $0.role ?? "", content: $0.message ?? "") }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if (messages.isEmpty) {
                    Spacer()
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.secondary)
                        .frame(width: 50, height: 50)
                    Text("No messages")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("Messages will appear when you start texting")
                        .foregroundStyle(.secondary)
                } else {
                    ScrollViewReader { scrollView in
                        ScrollView {
                            ForEach(messages, id: \.self) { message in
                                MessageView(message)
                            }
                        }.onChange(of: messages) { _ in
                            // FIXME: This doesn't work right now
                            // Scroll to the bottom when messages change
                            withAnimation {
                                scrollView.scrollTo(messages.count - 1, anchor: .bottom)
                            }
                        }.scrollDismissesKeyboard(.immediately)
                    }
                }
                Spacer()
                HStack {
                    TextField("Message", text: $msg)
                        .textFieldStyle(.roundedBorder)
                        .scrollDismissesKeyboard(.immediately)
                    if (loading) {
                        Spacer()
                        ProgressView()
                            .controlSize(.small)
                    } else {
                        Button(action: {
                            if (!msg.isEmpty) {
                                Task {
                                    loading = true
                                    do {
                                        let sentMessage = Message(role: "user", content: msg)
                                        messages.append(sentMessage)
                                        dataManager.saveChatHistory(role: sentMessage.role, message: sentMessage.content)
                                        let res  = try await ChadModel.shared.makeAPIRequest(msg)
                                        let systemMessages = res.choices.map { Message(role: "system", content: $0.message.content) }
                                        messages.append(contentsOf: systemMessages)
                                        systemMessages.forEach { dataManager.saveChatHistory(role: $0.role, message: $0.content) }
                                        msg = ""
                                    } catch {
                                        print("[ERROR] Failed to send message", error)
                                    }
                                    loading = false
                                }
                            }
                        }, label: {
                            Label("Send", systemImage: "paperplane")
                                .labelStyle(.iconOnly)
                        })
                    }
                }
            }.padding(.bottom, 3)
        }.toolbar {
            Button(action: { showSettings = true }, label: {
                Label("Settings", systemImage: "gearshape")
            })
        }.sheet(isPresented: $showSettings) {
            ChatSettingsView()
        }
        .padding(.horizontal)
        .navigationTitle("Chat with \(name)")
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
