// VotingEngineTests.swift
// Proves each ranking rule in VotingEngine, including both tie-breakers,
// so the winner shown on screen can be trusted.

import XCTest
@testable import MovieNight

final class VotingEngineTests: XCTestCase {

    private let alpha = Movie(id: 1, title: "Alpha", year: 2000, genre: "Drama", runtime: 90, synopsis: "A")
    private let bravo = Movie(id: 2, title: "Bravo", year: 2001, genre: "Comedy", runtime: 95, synopsis: "B")
    private let charlie = Movie(id: 3, title: "Charlie", year: 2002, genre: "Action", runtime: 100, synopsis: "C")

    private let ann = UUID()
    private let ben = UUID()

    func testHighestTotalWins() {
        let votes = [
            Vote(playerID: ann, movieID: 1, choice: .maybe),
            Vote(playerID: ann, movieID: 2, choice: .yes),
            Vote(playerID: ben, movieID: 2, choice: .yes)
        ]
        let results = VotingEngine.rank(movies: [alpha, bravo], votes: votes)
        XCTAssertEqual(results.first?.movie.title, "Bravo")
        XCTAssertEqual(results.first?.score, 4)
    }

    func testTieBrokenByMoreYesVotes() {
        // Both score 2, but Charlie has one Yes while Alpha has two Maybes.
        let votes = [
            Vote(playerID: ann, movieID: 1, choice: .maybe),
            Vote(playerID: ben, movieID: 1, choice: .maybe),
            Vote(playerID: ann, movieID: 3, choice: .yes),
            Vote(playerID: ben, movieID: 3, choice: .no)
        ]
        let results = VotingEngine.rank(movies: [alpha, charlie], votes: votes)
        XCTAssertEqual(results.first?.movie.title, "Charlie")
    }

    func testSecondTieBrokenAlphabetically() {
        // Same score and same Yes count, so the title decides.
        let votes = [
            Vote(playerID: ann, movieID: 2, choice: .yes),
            Vote(playerID: ann, movieID: 1, choice: .yes)
        ]
        let results = VotingEngine.rank(movies: [bravo, alpha], votes: votes)
        XCTAssertEqual(results.map { $0.movie.title }, ["Alpha", "Bravo"])
    }

    func testAllNoGivesScoreZero() {
        let votes = [
            Vote(playerID: ann, movieID: 1, choice: .no),
            Vote(playerID: ben, movieID: 1, choice: .no)
        ]
        let results = VotingEngine.rank(movies: [alpha], votes: votes)
        XCTAssertEqual(results.first?.score, 0)
        XCTAssertEqual(results.first?.yesCount, 0)
    }

    func testNoVotesReturnsAllMoviesWithScoreZero() {
        let results = VotingEngine.rank(movies: [alpha, bravo, charlie], votes: [])
        XCTAssertEqual(results.count, 3)
        XCTAssertTrue(results.allSatisfy { $0.score == 0 })
    }
}
