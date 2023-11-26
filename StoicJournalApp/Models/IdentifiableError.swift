//
//  IdentifiableError.swift
//  StoicJournalApp
//
//  Created by Rin Otori on 11/15/23.
//

import Foundation

struct MyIdentifiableError: Identifiable {
    let id = UUID()
    let message: String
}
