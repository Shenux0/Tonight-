// Player.swift
// One person taking part in a movie night. The name is editable on the home screen,
// so it is a `var`. The id is a UUID so two players can share a name safely.

import Foundation

struct Player: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var colorIndex: Int     // index into Theme.playerColors
}
