// MovieLoaderTests.swift
// Checks that the bundled movies.json is valid, because a broken file would
// leave the app with nothing to vote on.

import XCTest
@testable import MovieNight

final class MovieLoaderTests: XCTestCase {

    // The tests run inside the app, so the app bundle is found through an app class.
    private var appBundle: Bundle { Bundle(for: MovieNightViewModel.self) }

    func testMoviesJSONDecodes() {
        let movies = MovieLoader.loadMovies(from: appBundle)
        XCTAssertFalse(movies.isEmpty, "movies.json should decode into at least one movie")
    }

    func testThereAreTwentyMovies() {
        let movies = MovieLoader.loadMovies(from: appBundle)
        XCTAssertEqual(movies.count, 20)
    }

    func testMovieIDsAreUnique() {
        let movies = MovieLoader.loadMovies(from: appBundle)
        let uniqueIDs = Set(movies.map { $0.id })
        XCTAssertEqual(uniqueIDs.count, movies.count)
    }
}
