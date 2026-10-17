// SessionView.swift
// The voting session screen. It shows one of three stages (hand-off, voting, results)
// and cross-fades between them, so the session feels like one continuous screen.

import SwiftUI

struct SessionView: View {
    @Environment(MovieNightViewModel.self) private var vm

    var body: some View {
        ZStack {
            Theme.backgroundGradient.ignoresSafeArea()

            switch vm.stage {
            case .handoff:
                HandoffView().transition(.opacity)
            case .voting:
                VotingView().transition(.opacity)
            case .done:
                ResultsView().transition(.opacity)
            }
        }
        .animation(.easeInOut, value: vm.stage)
    }
}
