// MovieLoader.swift
// Reads the bundled movies.json file into [Movie].
// It never crashes: on any problem it returns an empty list and the UI shows a message.

import Foundation

enum MovieLoader {
    /// Reads movies.json from the app bundle. Returns [] if anything goes wrong,
    /// and the UI shows an error message instead of crashing.
    static func loadMovies(from bundle: Bundle = .main) -> [Movie] {
        guard let url = bundle.url(forResource: "movies", withExtension: "json") else {
            print("MovieLoader: movies.json is missing from the bundle")
            return []
        }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([Movie].self, from: data)
        } catch {
            print("MovieLoader: could not read movies.json: \(error)")
            return []
        }
    }
}
