// ResultsView.swift
// The winner reveal. A one-second pause builds suspense, then the winning poster
// springs in with the score and the two runners-up. From here the night is saved or replayed.

import SwiftUI
import SwiftData

struct ResultsView: View {
    @Environment(MovieNightViewModel.self) private var vm
    @Environment(\.modelContext) private var context
    @State private var revealed = false

    var body: some View {
        let results = vm.results

        ZStack {
            if revealed, let winner = results.first {
                revealedLayout(winner: winner, runnersUp: Array(results.dropFirst().prefix(2)))
            } else {
                Text("And the winner is…")
                    .font(.title)
                    .foregroundStyle(.secondary)
                    .transition(.opacity)
            }
        }
        .padding(Theme.screenPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task {
            // .task starts when the view appears and is cancelled if it disappears early.
            try? await Task.sleep(for: .seconds(1))
            withAnimation(.spring(response: 0.6, dampingFraction: 0.75)) {
                revealed = true
            }
        }
    }

    private func revealedLayout(winner: MovieResult, runnersUp: [MovieResult]) -> some View {
        HStack(spacing: 80) {
            PosterCard(movie: winner.movie, width: 400)
                .transition(.scale(scale: 0.8).combined(with: .opacity))

            VStack(alignment: .leading, spacing: 24) {
                Text("Tonight's pick")
                    .font(.caption)
                    .textCase(.uppercase)
                    .foregroundStyle(.secondary)
                Text(winner.movie.title)
                    .font(.largeTitle.bold())
                    .accessibilityIdentifier("winnerTitle")
                Text("\(winner.score) of \(vm.maxPossibleScore) points · \(winner.yesCount) yes votes")
                    .font(.headline)
                    .foregroundStyle(.secondary)

                if !runnersUp.isEmpty {
                    runnersUpList(runnersUp)
                }

                HStack(spacing: 30) {
                    Button {
                        vm.saveResult(in: context)
                        vm.returnToStart()
                    } label: {
                        Label("Save & Finish", systemImage: "checkmark")
                    }
                    .buttonStyle(PillButtonStyle(prominent: true))
                    .accessibilityIdentifier("saveFinishButton")

                    Button {
                        vm.voteAgain()
                    } label: {
                        Label("Vote Again", systemImage: "arrow.counterclockwise")
                    }
                    .buttonStyle(PillButtonStyle())
                    .accessibilityIdentifier("voteAgainButton")
                }
                .padding(.top, 20)
            }
            .frame(maxWidth: 800, alignment: .leading)
            .transition(.opacity)
        }
    }

    private func runnersUpList(_ runnersUp: [MovieResult]) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Runners-up")
                .font(.headline)
            ForEach(runnersUp) { result in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(result.movie.title)
                        Spacer()
                        Text("\(result.score) pts")
                            .foregroundStyle(.secondary)
                    }
                    // max(..., 1) avoids a zero total, which ProgressView cannot draw.
                    ProgressView(value: Double(result.score), total: Double(max(vm.maxPossibleScore, 1)))
                }
            }
        }
        .padding(.top, 20)
    }
}
