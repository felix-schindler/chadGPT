//
//  AsyncButton.swift
//  ChadGPT
//
//  Created by Felix Schindler on 15.06.23.
//

import SwiftUI

struct AsyncButton<Label: View>: View {
    /// Function to be performed on click
    var action: () async -> Void
    /// Optional button role
    var role: ButtonRole?
    
    /// Label
    @ViewBuilder private var label: () -> Label
    
    @State private var isPerformingTask = false
    
    var body: some View {
        Button(
            role: role,
            action: {
                isPerformingTask = true
                
                Task {
                    await action()
                    isPerformingTask = false
                }
            },
            label: {
                ZStack {
                    // Hide label without changing button size
                    label().opacity(isPerformingTask ? 0 : 1)
                    
                    // Show `ProgressView` while waiting for `Task` to finish
                    if (isPerformingTask) {
                        ProgressView()
                    }
                }
            }
        )
        .disabled(isPerformingTask)
    }
}

/// For async buttons with only a Text as Label
extension AsyncButton where Label == Text {
    init(_ label: String,
         role: ButtonRole? = nil,
         action: @escaping () async -> Void) {
        self.init(action: action, role: role) {
            Text(label)
        }
    }
}

/// For async buttons with only an Image as Label
extension AsyncButton where Label == Image {
    init(systemImage: String,
         role: ButtonRole? = nil,
         action: @escaping () async -> Void) {
        self.init(action: action, role: role) {
            Image(systemName: systemImage)
        }
    }
}
