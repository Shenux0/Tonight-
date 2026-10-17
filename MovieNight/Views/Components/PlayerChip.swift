// PlayerChip.swift
// One player on the home screen: a coloured initial and an editable name.
// It takes a Binding so typing here changes the player stored in the view model.

import SwiftUI

struct PlayerChip: View {
    @Binding var player: Player

    // Shows "?" while the name is empty instead of a blank circle.
    private var initial: String {
        player.name.isEmpty ? "?" : String(player.name.prefix(1)).uppercased()
    }

    var body: some View {
        VStack(spacing: 20) {
            Circle()
                .fill(Theme.color(for: player))
                .frame(width: 100, height: 100)
                .overlay {
                    Text(initial)
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)
                }

            // Kept narrow so six chips still fit across the screen.
            TextField("Name", text: $player.name)
                .frame(width: 200)
        }
        .padding(24)
        .background(RoundedRectangle(cornerRadius: Theme.cornerRadius).fill(.regularMaterial))
    }
}
