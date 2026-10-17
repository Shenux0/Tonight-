// MovieNightViewModelTests.swift
// Walks the view model through a whole session (setup, turns, hand-offs, finish)
// using a small fake movie list, so the tests do not depend on movies.json.

import XCTest
@testable import MovieNight

final class MovieNightViewModelTests: XCTestCase {

    private func makeMovies(count: Int) -> [Movie] {
        (1...count).map { number in
            Movie(id: number, title: "Movie \(number)", year: 2000, genre: "Drama", runtime: 90, synopsis: "Test")
        }
    }

    private func makeViewModel(moviesPerSession: Int = 3) -> MovieNightViewModel {
        MovieNightViewModel(movies: makeMovies(count: 10), moviesPerSession: moviesPerSession)
    }

    func testStartSessionPicksExactlyMoviesPerSession() {
        let vm = makeViewModel(moviesPerSession: 8)
        vm.startSession()
        XCTAssertEqual(vm.sessionMovies.count, 8)
        XCTAssertEqual(vm.stage, .handoff)
    }

    func testCastMovesToNextMovie() {
        let vm = makeViewModel()
        vm.startSession()
        vm.beginTurn()
        vm.cast(.yes)
        XCTAssertEqual(vm.currentMovieIndex, 1)
        XCTAssertEqual(vm.votes.count, 1)
        XCTAssertEqual(vm.stage, .voting)
    }

    func testAfterLastMovieOfPlayerStageIsHandoff() {
        let vm = makeViewModel()
        vm.startSession()
        vm.beginTurn()
        for _ in 0..<3 { vm.cast(.maybe) }
        XCTAssertEqual(vm.stage, .handoff)
        XCTAssertEqual(vm.currentPlayerIndex, 1)
        XCTAssertEqual(vm.currentMovieIndex, 0)
    }

    func testAfterLastPlayerStageIsDone() {
        let vm = makeViewModel()
        vm.startSession()
        for _ in vm.players {
            vm.beginTurn()
            for _ in 0..<3 { vm.cast(.no) }
        }
        XCTAssertEqual(vm.stage, .done)
        XCTAssertEqual(vm.votes.count, 6)
    }

    func testAddPlayerStopsAtSix() {
        let vm = makeViewModel()
        for _ in 0..<10 { vm.addPlayer() }
        XCTAssertEqual(vm.players.count, 6)
    }

    func testRemoveLastPlayerStopsAtTwo() {
        let vm = makeViewModel()
        for _ in 0..<5 { vm.removeLastPlayer() }
        XCTAssertEqual(vm.players.count, 2)
    }

    func testBlankNamesBecomePlayerN() {
        let vm = makeViewModel()
        vm.players[0].name = "   "
        vm.players[1].name = ""
        vm.startSession()
        XCTAssertEqual(vm.players.map { $0.name }, ["Player 1", "Player 2"])
    }
}
