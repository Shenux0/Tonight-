// MovieNightApp.swift
// The app's entry point. It shows RootView and sets up the SwiftData store
// that keeps the history of past movie nights.

import SwiftUI
import SwiftData

@main
struct MovieNightApp: App {
    var body: some Scene {
        WindowGroup { RootView() }
            .modelContainer(for: MovieNightRecord.self)
    }
}
