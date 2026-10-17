// RootView.swift
// Creates the single view model and the navigation stack for the whole app.
// The view model is shared through the environment so every screen sees the same state.

import SwiftUI

struct RootView: View {
    @State private var viewModel = MovieNightViewModel()

    var body: some View {
        NavigationStack(path: $viewModel.path) {
            PlayersView()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .session: SessionView()
                    case .history: HistoryView()
                    }
                }
        }
        .environment(viewModel)
    }
}
