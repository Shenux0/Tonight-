// VotingView.swift
// The main screen: one movie at a time with Yes / Maybe / No buttons.
// The buttons sit outside the animated content, so focus stays put as movies slide past.

import SwiftUI

struct VotingView: View {
    @Environment(MovieNightViewModel.self) private var vm

    // New movie slides in from the right, the old one slides out to the left.
    private let slide = AnyTransition.asymmetric(
        insertion: .move(edge: .trailing).combined(with: .opacity),
        removal: .move(edge: .leading).combined(with: .opacity)
    )

    var body: some View {
        let player = vm.currentPlayer
        let color = Theme.color(for: player)

        VStack(alignment: .leading, spacing: Theme.groupSpacing) {
            VStack(spacing: 16) {
                HStack {
                    Circle().fill(color).frame(width: 24, height: 24)
                    Text(player.name).font(.headline)
                    Spacer()
                    Text(vm.progressText).font(.headline).foregroundStyle(.secondary)
                }
                ProgressView(value: vm.progressFraction)
                    .tint(color)
            }

            if let movie = vm.currentMovie {
                HStack(alignment: .top, spacing: 60) {
                    PosterCard(movie: movie, width: 340)
                        .id(movie.id)
                        .transition(slide)

                    VStack(alignment: .leading, spacing: Theme.groupSpacing) {
                        details(for: movie)
                            .id(movie.id)
                            .transition(slide)
                        voteButtons
                    }
                }
            }

            Spacer(minLength: 0)
        }
        .padding(Theme.screenPadding)
    }

    private func details(for movie: Movie) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(movie.title)
                .font(.largeTitle.bold())
                .lineLimit(2)
            // String(...) stops the numbers being shown as "1,995".
            Text("\(String(movie.year)) · \(movie.genre) · \(String(movie.runtime)) min")
                .font(.headline)
                .foregroundStyle(.secondary)
            Text(movie.synopsis)
                .font(.body)
        }
        // A fixed minimum height stops the buttons jumping up and down between movies.
        .frame(maxWidth: 700, minHeight: 340, alignment: .topLeading)
    }

    private var voteButtons: some View {
        HStack(spacing: 30) {
            voteButton("Yes", systemImage: "hand.thumbsup.fill", choice: .yes, identifier: "yesButton")
            voteButton("Maybe", systemImage: "questionmark", choice: .maybe, identifier: "maybeButton")
            voteButton("No", systemImage: "hand.thumbsdown.fill", choice: .no, identifier: "noButton")
        }
    }

    private func voteButton(_ title: String, systemImage: String,
                            choice: VoteChoice, identifier: String) -> some View {
        Button {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                vm.cast(choice)
            }
        } label: {
            Label(title, systemImage: systemImage)
        }
        .buttonStyle(PillButtonStyle())
        .accessibilityIdentifier(identifier)
    }
}
