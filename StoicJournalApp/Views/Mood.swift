//
//  Mood.swift
//  StoicJournalApp
//
//  Created by Rin Otori on 11/20/23.
//

import Foundation

struct Mood: Codable, Identifiable, Hashable {
    var id: String
    var icon: String
    var description: String

    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
