//
//  MessageListView.swift
//  ChadGPT
//
//  Created by Felix Schindler on 17.05.23.
//

import SwiftUI

struct MessageView: View {
    @State var message: Message
    
    init(_ message: Message) {
        self.message = message
    }
    
    var body: some View {
        HStack {
            if (message.role == "user") {
                Spacer()
                Text(message.content)
                    .padding(7.5)
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
                    .textSelection(.enabled)
            } else {
                Text(message.content)
                    .padding(7.5)
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                    .textSelection(.enabled)
                Spacer()
            }
        }
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MessageView(
                Message(role: "user", content: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.")
            )
            MessageView(
                Message(role: "other", content: "Lorem ipsum")
            )
        }.padding()
    }
}
