// HandoffView.swift
// Shown between turns so the next person takes the remote before any movie appears.
// This keeps each player's votes private from the one before.

import SwiftUI

struct HandoffView: View {
    @Environment(MovieNightViewModel.self) private var vm

    var body: some View {
        let player = vm.currentPlayer

        VStack(spacing: Theme.groupSpacing) {
            Circle()
                .fill(Theme.color(for: player))
                .frame(width: 200, height: 200)
                .overlay {
                    Text(player.name.isEmpty ? "?" : String(player.name.prefix(1)).uppercased())
                        .font(.system(size: 96, weight: .bold))
                        .foregroundStyle(.white)
                }

            VStack(spacing: 16) {
                Text("\(player.name)'s turn")
                    .font(.largeTitle.bold())
                Text("Pass the remote to \(player.name). You'll vote on \(vm.sessionMovies.count) movies.")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            Button {
                vm.beginTurn()
            } label: {
                Label("I'm Ready", systemImage: "play.fill")
            }
            .buttonStyle(PillButtonStyle(prominent: true))
            .accessibilityIdentifier("readyButton")
        }
        .padding(Theme.screenPadding)
    }
}
