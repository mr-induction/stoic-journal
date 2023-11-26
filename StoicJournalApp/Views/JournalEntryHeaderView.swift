//
//  JournalEntryHeaderView.swift
//  StoicJournalApp
//
//  Created by Rin Otori on 11/16/23.
//

import SwiftUI

struct JournalEntryHeaderView: View {
    var title: String // Title of the journal entry
    var date: Date // Date when the journal entry was created
    
    var body: some View {
        VStack(alignment: .leading) {
            // Display the title using a headline font
            Text(title)
                .font(.headline)
            
            // Display the date in a subheadline font with the date style
            Text(date, style: .date)
                .font(.subheadline)
        }
    }
}
