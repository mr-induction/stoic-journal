//
//  JournalEntryFooterView.swift
//  StoicJournalApp
//
//  Created by Rin Otori on 11/16/23.
//

import SwiftUI

struct JournalEntryFooterView: View {
    var moodId: String // Mood identifier
    var tags: [String] // Tags associated with the entry
    var stoicResponse: String? // Stoic response text
    
    var body: some View {
        VStack {
            // Safely unwrap `stoicResponse` and check if it's not empty
            if let response = stoicResponse, !response.isEmpty {
                // Display the Stoic response if it exists and is not empty
                Text("Stoic Response: \(response)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            HStack {
                // Display the mood identifier
                Text("Mood: \(moodId)")
                Spacer()
                // Display the tags as a comma-separated list
                Text("Tags: \(tags.joined(separator: ", "))")
            }
        }
    }
}
