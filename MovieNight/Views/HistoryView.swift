// HistoryView.swift
// Lists past movie nights saved with SwiftData, newest first.
// @Query keeps the list up to date by itself, so saving or clearing refreshes the screen.

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \MovieNightRecord.date, order: .reverse) private var records: [MovieNightRecord]
    @State private var showClearConfirmation = false

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.groupSpacing) {
            HStack {
                Text("Past Movie Nights")
                    .font(.largeTitle.bold())
                Spacer()
                if !records.isEmpty {
                    Button {
                        showClearConfirmation = true
                    } label: {
                        Label("Clear History", systemImage: "trash")
                    }
                    .buttonStyle(PillButtonStyle())
                    .accessibilityIdentifier("clearHistoryButton")
                }
            }

            if records.isEmpty {
                emptyState
            } else {
                recordList
            }
        }
        .padding(Theme.screenPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Theme.backgroundGradient.ignoresSafeArea())
        .confirmationDialog("Clear all past movie nights?",
                            isPresented: $showClearConfirmation,
                            titleVisibility: .visible) {
            Button("Clear History", role: .destructive) { clearHistory() }
            Button("Cancel", role: .cancel) {}
        }
    }

    private var recordList: some View {
        ScrollView {
            LazyVStack(spacing: 30) {
                ForEach(records) { record in
                    // On tvOS only focusable views can be scrolled to, so each row is a
                    // button that does nothing when pressed.
                    // MAC-CHECK: check the .card style looks right with the material background.
                    Button(action: {}) {
                        row(for: record)
                    }
                    .buttonStyle(.card)
                }
            }
            .padding(30)   // room for the focus lift so it is not clipped
        }
    }

    private func row(for record: MovieNightRecord) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(record.winnerTitle)
                .font(.headline)
            Text(record.date.formatted(date: .abbreviated, time: .shortened))
                .foregroundStyle(.secondary)
            Text(record.playerNames.joined(separator: ", "))
        }
        .padding(30)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: Theme.cornerRadius).fill(.regularMaterial))
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "film.stack")
                .font(.system(size: 100))
                .foregroundStyle(.secondary)
            Text("No movie nights yet")
                .font(.title2.bold())
            Text("Finish a vote to see it here.")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func clearHistory() {
        for record in records {
            context.delete(record)
        }
    }
}
