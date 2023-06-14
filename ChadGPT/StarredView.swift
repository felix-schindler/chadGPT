//
//  StarredView.swift
//  ChadGPT
//
//  Created by Felix Schindler on 17.05.23.
//

import SwiftUI

struct StarredView: View {
    @State var starred: [String] = []
    @ObservedObject var dataManager = DataManager.shared
    
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
                                    dataManager.deleteItem(withContent: line)
                                    reloadStarredList()
                                }, label: {
                                    Label("Remove starred", systemImage: "star.slash")
                                })
                            }
                    }
                }
            }.navigationTitle("Starred")
        }.onAppear {
            reloadStarredList()
        }
    }
    
    func reloadStarredList() {
        starred = []
        for line in dataManager.loadPickUpLines() {
            starred.append(line.content ?? "")
        }
    }
}

struct StarredView_Previews: PreviewProvider {
    static var previews: some View {
        StarredView()
    }
}
