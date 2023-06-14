//
//  MessageListView.swift
//  ChadGPT
//
//  Created by Felix Schindler on 17.05.23.
//

import SwiftUI

struct MessageView: View {
    @State var msg: Message
    
    init(_ message: Message) {
        self.msg = message
    }
    
    var body: some View {
        HStack {
            if (msg.role == "user") {
                Spacer()
                Text(msg.content)
                    .padding(5)
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
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

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MessageView(
                Message(role: "user", content: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.")
            )
        }.padding()
    }
}
