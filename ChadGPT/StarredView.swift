//
//  StarredView.swift
//  ChadGPT
//
//  Created by Felix Schindler on 17.05.23.
//

import SwiftUI

struct StarredView: View {
    @State var starred: [String] = ["You're a bit smelly"]
    
    var body: some View {
        NavigationView {
            List {
                if (starred.isEmpty) {
                    Text("Starred pick up lines will show up here")
                } else {
                    ForEach(starred, id: \.self) { line in
                        Text(line)
                            .swipeActions {
                                Button(role: .destructive, action: {
                                    // TODO: Remove from starred
                                    starred = []
                                }, label: {
                                    Label("Remove starred", systemImage: "star.slash")
                                })
                            }
                    }
                }
            }.navigationTitle("Starred")
        }
    }
}

struct StarredView_Previews: PreviewProvider {
    static var previews: some View {
        StarredView()
    }
}
