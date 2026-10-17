// MovieResult.swift
// The final tally for one movie after everyone has voted.
// VotingEngine produces these; the results screen only displays them.

import Foundation

struct MovieResult: Identifiable {
    let movie: Movie
    let score: Int          // sum of points
    let yesCount: Int
    var id: Int { movie.id }
}
