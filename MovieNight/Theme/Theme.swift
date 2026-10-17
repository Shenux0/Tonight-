// Theme.swift
// Every colour, size and spacing value in one place, so the whole app keeps
// the same calm Apple TV look and a design change only touches this file.

import SwiftUI

enum Theme {
    static let accent = Color.indigo
    static let cornerRadius: CGFloat = 28
    static let screenPadding = EdgeInsets(top: 60, leading: 80, bottom: 60, trailing: 80)
    static let groupSpacing: CGFloat = 40

    // The subtle tint that sits on top of the system background on every screen.
    static let backgroundGradient = LinearGradient(colors: [accent.opacity(0.25), .clear],
                                                   startPoint: .top, endPoint: .bottom)

    // Fixed palette: a player picks by index, so colors never repeat in one session.
    static let playerColors: [Color] = [.blue, .green, .orange, .pink, .purple, .teal]

    // Poster gradients: chosen from movie.id so a movie always gets the same colors.
    static let posterGradients: [[Color]] = [
        [.indigo, .purple], [.orange, .pink], [.teal, .blue],
        [.green, .teal], [.pink, .purple], [.blue, .indigo]
    ]

    static func gradient(for movie: Movie) -> LinearGradient {
        let colors = posterGradients[movie.id % posterGradients.count]
        return LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    // The modulo keeps any index safe, even one outside the palette.
    static func color(for player: Player) -> Color {
        playerColors[player.colorIndex % playerColors.count]
    }
}
