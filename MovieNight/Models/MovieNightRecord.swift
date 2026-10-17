// MovieNightRecord.swift
// A saved movie night, stored with SwiftData so the history survives app restarts.
// It keeps plain values (title, names) instead of links to Movie or Player,
// because those structs are not stored in the database.

import Foundation
import SwiftData

@Model
final class MovieNightRecord {
    var date: Date
    var winnerTitle: String
    var winnerScore: Int
    var maxScore: Int
    var playerNames: [String]

    init(date: Date = .now, winnerTitle: String, winnerScore: Int, maxScore: Int, playerNames: [String]) {
        self.date = date
        self.winnerTitle = winnerTitle
        self.winnerScore = winnerScore
        self.maxScore = maxScore
        self.playerNames = playerNames
    }
}
