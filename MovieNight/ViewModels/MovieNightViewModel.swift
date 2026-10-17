// MovieNightViewModel.swift
// Owns all state for a movie night: navigation, players, votes and progress.
// Views only read from it and call its methods, so every rule lives in one place.

import Foundation
import Observation
import SwiftData   // only needed for ModelContext in saveResult

enum Route: Hashable { case session, history }
enum SessionStage { case handoff, voting, done }

@Observable
final class MovieNightViewModel {
    // Navigation (the view model owns the path so any screen can reset to the start)
    var path: [Route] = []

    // Setup
    var players: [Player] = [Player(name: "Player 1", colorIndex: 0),
                             Player(name: "Player 2", colorIndex: 1)]
    let allMovies: [Movie]
    let moviesPerSession: Int

    // Session state
    private(set) var sessionMovies: [Movie] = []
    private(set) var votes: [Vote] = []
    private(set) var currentPlayerIndex = 0
    private(set) var currentMovieIndex = 0
    private(set) var stage: SessionStage = .handoff

    static let minPlayers = 2
    static let maxPlayers = 6

    init(movies: [Movie] = MovieLoader.loadMovies(), moviesPerSession: Int = 8) {
        self.allMovies = movies
        self.moviesPerSession = moviesPerSession
    }

    // MARK: Setup actions

    func addPlayer() {
        guard players.count < Self.maxPlayers else { return }
        // Pick the first colour nobody is using, so colours never repeat.
        let usedColors = players.map { $0.colorIndex }
        let freeColor = (0..<Self.maxPlayers).first { !usedColors.contains($0) } ?? players.count
        players.append(Player(name: "Player \(players.count + 1)", colorIndex: freeColor))
    }

    func removeLastPlayer() {
        guard players.count > Self.minPlayers else { return }
        players.removeLast()
    }

    // MARK: Computed values

    var canStart: Bool { players.count >= Self.minPlayers && !allMovies.isEmpty }

    var currentPlayer: Player {
        // Fallback keeps the UI safe if the index is ever out of range.
        players.indices.contains(currentPlayerIndex)
            ? players[currentPlayerIndex]
            : Player(name: "Player", colorIndex: 0)
    }

    var currentMovie: Movie? {
        sessionMovies.indices.contains(currentMovieIndex) ? sessionMovies[currentMovieIndex] : nil
    }

    var progressText: String {
        let shown = min(currentMovieIndex + 1, sessionMovies.count)
        return "\(shown) / \(sessionMovies.count)"
    }

    var progressFraction: Double {
        guard !sessionMovies.isEmpty else { return 0 }
        return Double(currentMovieIndex) / Double(sessionMovies.count)
    }

    var results: [MovieResult] { VotingEngine.rank(movies: sessionMovies, votes: votes) }

    var maxPossibleScore: Int { players.count * VoteChoice.yes.points }

    // MARK: Session actions

    func startSession() {
        for index in players.indices {
            let trimmed = players[index].name.trimmingCharacters(in: .whitespacesAndNewlines)
            players[index].name = trimmed.isEmpty ? "Player \(index + 1)" : trimmed
        }
        sessionMovies = Array(allMovies.shuffled().prefix(moviesPerSession))
        votes = []
        currentPlayerIndex = 0
        currentMovieIndex = 0
        stage = .handoff
    }

    func beginTurn() {
        stage = .voting
    }

    func cast(_ choice: VoteChoice) {
        guard let movie = currentMovie else { return }
        votes.append(Vote(playerID: currentPlayer.id, movieID: movie.id, choice: choice))

        if currentMovieIndex + 1 < sessionMovies.count {
            currentMovieIndex += 1                  // same player, next movie
        } else if currentPlayerIndex + 1 < players.count {
            currentPlayerIndex += 1                 // next player starts from the first movie
            currentMovieIndex = 0
            stage = .handoff
        } else {
            stage = .done                           // everyone has voted
        }
    }

    func saveResult(in context: ModelContext) {
        guard let winner = results.first else { return }
        let record = MovieNightRecord(winnerTitle: winner.movie.title,
                                      winnerScore: winner.score,
                                      maxScore: maxPossibleScore,
                                      playerNames: players.map { $0.name })
        context.insert(record)
    }

    func returnToStart() {
        path = []
    }

    func voteAgain() {
        startSession()   // same players, new shuffle; the path is unchanged so we stay on the session screen
    }
}
