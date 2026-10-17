// VotingEngine.swift
// Turns a list of votes into a ranked list of results. Pure logic with no UI and
// no stored state, so the same input always gives the same output and it is easy to test.

import Foundation

enum VotingEngine {
    /// Ranks movies from best to worst.
    /// Rule 1: higher total points wins.
    /// Rule 2 (tie): more "Yes" votes wins.
    /// Rule 3 (still tied): alphabetical by title, so the result is always the same.
    static func rank(movies: [Movie], votes: [Vote]) -> [MovieResult] {
        let results = movies.map { movie in
            let votesForMovie = votes.filter { $0.movieID == movie.id }
            let score = votesForMovie.reduce(0) { total, vote in total + vote.choice.points }
            let yesCount = votesForMovie.filter { $0.choice == .yes }.count
            return MovieResult(movie: movie, score: score, yesCount: yesCount)
        }

        return results.sorted { first, second in
            if first.score != second.score {
                return first.score > second.score
            }
            if first.yesCount != second.yesCount {
                return first.yesCount > second.yesCount
            }
            return first.movie.title < second.movie.title
        }
    }
}
