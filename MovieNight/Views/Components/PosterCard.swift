// PosterCard.swift
// A stand-in movie poster: a coloured gradient card with the title and year.
// Drawing it in code means no image files and no copyright worries.

import SwiftUI

struct PosterCard: View {
    let movie: Movie
    var width: CGFloat = 340

    var body: some View {
        RoundedRectangle(cornerRadius: Theme.cornerRadius)
            .fill(Theme.gradient(for: movie))
            .frame(width: width, height: width * 1.5)   // 2:3 poster ratio
            .overlay(alignment: .bottomLeading) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(movie.title)
                        .font(.headline)
                        .foregroundStyle(.white)
                    // String(...) stops the year being shown as "1,995".
                    Text(String(movie.year))
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                }
                .padding(24)
            }
            .shadow(radius: 20, y: 10)
            .accessibilityElement(children: .combine)
    }
}
