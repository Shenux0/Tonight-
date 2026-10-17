// PillButtonStyle.swift
// The app's one custom button look: a capsule that grows and lifts when focused.
// A ButtonStyle cannot read focus itself, so it hands the work to a small private view.

import SwiftUI

struct PillButtonStyle: ButtonStyle {
    var prominent = false

    func makeBody(configuration: Configuration) -> some View {
        PillButtonBody(configuration: configuration, prominent: prominent)
    }
}

private struct PillButtonBody: View {
    let configuration: ButtonStyle.Configuration
    let prominent: Bool
    // MAC-CHECK: confirm isFocused updates inside a ButtonStyle body on the tvOS 17 simulator.
    @Environment(\.isFocused) private var isFocused
    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        configuration.label
            .font(.headline)
            .padding(.horizontal, 40)
            .padding(.vertical, 20)
            .background(Capsule().fill(prominent ? Theme.accent : Color.secondary.opacity(0.25)))
            .foregroundStyle(prominent ? Color.white : Color.primary)
            .opacity(isEnabled ? 1.0 : 0.4)   // disabled buttons look faded
            .scaleEffect(isFocused ? 1.08 : 1.0)
            .shadow(radius: isFocused ? 20 : 0, y: isFocused ? 10 : 0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
    }
}
