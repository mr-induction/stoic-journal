//
//  DailyQuoteSection.swift
//  StoicJournalApp
//
//  Created by Rin Otori on 11/15/23.
//

import SwiftUI

// Define a simple Quote struct
struct Quote: Identifiable, Codable {
    var id: UUID = UUID()
    var text: String
    var author: String
}

struct DailyQuoteView: View {
    @State private var dailyQuote: Quote = Quote(text: "Loading...", author: "")
    // State for tracking if a quote is favorited (This can be replaced with your actual favoriting logic)
    @State private var isFavorited: Bool = false

    var body: some View {
        VStack {
            Text(dailyQuote.text)
                .font(.title)
                .padding()

            Text("- \(dailyQuote.author)")
                .font(.headline)
                .padding()

            HStack {
                Button(action: {
                    // Handle the logic for favoriting the quote
                    self.isFavorited.toggle()
                }) {
                    Label("Favorite", systemImage: isFavorited ? "heart.fill" : "heart")
                }

                Button(action: {
                    // Handle the logic for sharing the quote
                    shareQuote()
                }) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
            }
            .padding()
        }
        .onAppear {
            loadDailyQuote()
        }
    }

    private func loadDailyQuote() {
        // Load the daily quote from your data source
        // This is just a placeholder, replace with real data fetching
        dailyQuote = Quote(text: "To be yourself in a world that is constantly trying to make you something else is the greatest accomplishment.", author: "Ralph Waldo Emerson")
    }

    private func shareQuote() {
        // Implement the logic to share the quote
        // This could involve UIActivityViewController in UIKit, wrapped in a UIViewControllerRepresentable
    }
}

struct DailyQuoteView_Previews: PreviewProvider {
    static var previews: some View {
        DailyQuoteView()
    }
}
