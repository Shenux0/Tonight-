// PlayersView.swift
// The home screen ("Who's watching?"). The group adds 2-6 players, types names,
// then starts voting. It also leads to the history of past nights.

import SwiftUI

struct PlayersView: View {
    @Environment(MovieNightViewModel.self) private var vm

    var body: some View {
        // @Bindable lets us hand a binding to each player's name to PlayerChip.
        @Bindable var vm = vm

        VStack(spacing: Theme.groupSpacing) {
            HStack {
                Spacer()
                Button {
                    vm.path.append(.history)
                } label: {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
                .buttonStyle(PillButtonStyle())
                .accessibilityIdentifier("historyButton")
            }

            Spacer(minLength: 0)

            VStack(spacing: 12) {
                Text("Tonight?")
                    .font(.largeTitle.bold())
                Text("Who's watching?")
                    .font(.title)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 30) {
                ForEach($vm.players) { $player in
                    PlayerChip(player: $player)
                }
            }

            HStack(spacing: 30) {
                Button {
                    vm.addPlayer()
                } label: {
                    Label("Add Player", systemImage: "plus")
                }
                .buttonStyle(PillButtonStyle())
                .disabled(vm.players.count >= MovieNightViewModel.maxPlayers)
                .accessibilityIdentifier("addPlayerButton")

                Button {
                    vm.removeLastPlayer()
                } label: {
                    Label("Remove", systemImage: "minus")
                }
                .buttonStyle(PillButtonStyle())
                .disabled(vm.players.count <= MovieNightViewModel.minPlayers)

                startButtonOrError
            }

            Spacer(minLength: 0)
        }
        .padding(Theme.screenPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.backgroundGradient.ignoresSafeArea())
    }

    // Without movies there is nothing to vote on, so we explain instead of offering Start.
    @ViewBuilder
    private var startButtonOrError: some View {
        if vm.allMovies.isEmpty {
            Text("Couldn't load the movie list.")
                .font(.headline)
                .foregroundStyle(.secondary)
        } else {
            Button {
                vm.startSession()          // set up the session before showing it
                vm.path.append(.session)
            } label: {
                Label("Start Voting", systemImage: "play.fill")
            }
            .buttonStyle(PillButtonStyle(prominent: true))
            .disabled(!vm.canStart)
            .accessibilityIdentifier("startVotingButton")
        }
    }
}
