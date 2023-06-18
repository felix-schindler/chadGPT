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
    @State var messages: [Message] = []
    
    @State var loading = false
    @State var msg = ""
    
    @State var showSettings = false
    let chad = ChadModel.shared
    let helper = ViewHelper()
    
    @ObservedObject var dataManager = DataManager.shared
    
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
                        }/*.onChange(of: messages) { _ in
                          // FIXME: This doesn't work right now
                          // Scroll to the bottom when messages change
                          withAnimation {
                          scrollView.scrollTo(messages.count - 1, anchor: .bottom)
                          }
                          }*/.scrollDismissesKeyboard(.interactively)
                    }
                }
                Spacer()
                HStack {
                    TextField("Message", text: $msg)
                        .accessibilityIdentifier("user-msg")
                        .textFieldStyle(.roundedBorder)
                    if (loading) {
                        Spacer()
                        ProgressView()
                            .controlSize(.small)
                    } else {
                        AsyncButton(systemImage: "paperplane") {
                            if (msg.isNotEmpty) {
                                let sentMessage = Message(role: "user", content: msg)
                                msg = ""
                                messages.append(sentMessage)
                                dataManager.saveChatHistory(role: sentMessage.role, message: sentMessage.content)
                                let systemMessages = await chad.sendMessage(messages)
                                messages.append(contentsOf: systemMessages)
                                systemMessages.forEach { dataManager.saveChatHistory(role: $0.role, message: $0.content) }
                            }
                        }.accessibilityIdentifier("send-msg")
                            .buttonStyle(.bordered)
                            .clipShape(Circle())
                    }
                }.padding(.bottom, 5)
            }.toolbar {
                Button(action: { showSettings = true }, label: {
                    Label("Settings", systemImage: "gearshape")
                }).accessibilityIdentifier("open-settings")
            }.sheet(isPresented: $showSettings, onDismiss: {
                name = ChadModel.shared.settings.name
            }) {
                ChatSettingsView(callback: {
                    messages = helper.loadChatHistory()
                } , name: $name)
            }.onAppear {
                self.name = chad.settings.name
                messages = helper.loadChatHistory()
            }
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
