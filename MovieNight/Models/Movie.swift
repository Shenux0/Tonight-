// Movie.swift
// One film the group can vote on. Loaded from movies.json, so it is Codable,
// and the fields match the JSON keys exactly.

import Foundation

struct Movie: Identifiable, Codable, Hashable {
    let id: Int
    let title: String
    let year: Int
    let genre: String
    let runtime: Int        // minutes
    let synopsis: String    // one short sentence, written by us
}
