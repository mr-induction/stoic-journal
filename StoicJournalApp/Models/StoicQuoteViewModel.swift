//
//  StoicQuoteViewModel.swift
//  StoicJournalApp
//
//  Created by Rin Otori on 11/15/23.
//

import Foundation
import Combine

class StoicQuoteViewModel: ObservableObject {
    @Published var dailyStoicQuote: String = stoicQuotes.first ?? "Default Stoic Quote"
    private var lastUpdatedDate = Date()

    init() {
        updateDailyQuote()
    }

    func updateDailyQuote() {
        let today = Calendar.current.startOfDay(for: Date())
        if !Calendar.current.isDate(lastUpdatedDate, inSameDayAs: today) {
            lastUpdatedDate = today
            let quoteIndex = Calendar.current.component(.day, from: today) % stoicQuotes.count
            dailyStoicQuote = stoicQuotes[quoteIndex]
        }
    }
}
