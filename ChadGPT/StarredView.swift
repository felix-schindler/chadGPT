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
    let helper = ViewHelper()
    
    var body: some View {
        NavigationView {
            if (starred.isEmpty) {
                VStack {
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.secondary)
                        .frame(width: 50, height: 50)
                    Text("No favourites")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("Swipe a pickup line to mark as favourite")
                        .foregroundStyle(.secondary)
                }.navigationTitle("Starred")
                    .padding()
            } else {
                List(starred, id: \.self) { line in
                    Text(line)
                        .swipeActions {
                            Button(role: .destructive, action: {
                                dataManager.deleteItem(withContent: line)
                                starred = helper.reloadStarredList()
                            }, label: {
                                Label("Remove starred", systemImage: "star.slash")
                            })
                        }
                }.navigationTitle("Starred")
            }
        }.onAppear {
            starred = helper.reloadStarredList()
        }
    }
}

struct StarredView_Previews: PreviewProvider {
    static var previews: some View {
        StarredView()
    }
}
