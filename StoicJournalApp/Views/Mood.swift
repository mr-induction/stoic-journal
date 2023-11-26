//
//  Mood.swift
//  StoicJournalApp
//
//  Created by Rin Otori on 11/20/23.
//

import Foundation

struct Mood: Identifiable, Encodable, Hashable {
    let id: String
    let icon: String
    let description: String
}
