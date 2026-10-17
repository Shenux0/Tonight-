// Vote.swift
// A single player's answer for a single movie.
// The raw values double as points, so scoring is just "add up the raw values".

import Foundation

enum VoteChoice: Int, Codable {
    case no = 0, maybe = 1, yes = 2
    var points: Int { rawValue }   // Yes = 2, Maybe = 1, No = 0
}

struct Vote {
    let playerID: UUID
    let movieID: Int
    let choice: VoteChoice
}
