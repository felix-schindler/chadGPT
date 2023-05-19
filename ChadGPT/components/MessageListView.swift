//
//  MessageListView.swift
//  ChadGPT
//
//  Created by Felix Schindler on 17.05.23.
//

import SwiftUI

struct MessageListView: View {
    @Binding var messages: [Message]
    
    var body: some View {
        ForEach(messages, id: \.self) { msg in
            HStack {
                if (msg.sender == .human) {
                    Spacer()
                    Text(msg.content)
                        .padding(5)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .textSelection(.enabled)
                } else {
                    Text(msg.content)
                        .padding(5)
                        .background(Color(.systemGray4))
                        .cornerRadius(10)
                        .textSelection(.enabled)
                    Spacer()
                }
            }
        }
    }
}

struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MessageListView(messages: .constant([
                Message(sender: .human, content: "Hi"),
                Message(sender: .bot, content: "Hello, yourself."),
                Message(sender: .human, content: "Thank you"),
                Message(sender: .bot, content: "No problem"),
                Message(sender: .human, content: "Write a longer text"),
                Message(sender: .bot, content: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."),
            ]))
        }.padding()
    }
}
