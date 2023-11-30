//
//  JournalEntryViewModel.swift
//  StoicJournalApp
//
//  Created by Rin Otori on 11/29/23.
//

import SwiftUI

class JournalEntryViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var selectedTag: JournalTag? = nil
    @Published var selectedMood: Mood? = nil
    @Published var isSaving = false

    var journalViewModel: JournalViewModel

    init(journalViewModel: JournalViewModel) {
        self.journalViewModel = journalViewModel
    }

    func saveJournalEntry() {
        self.isSaving = true

        // Corrected Tag Conversion Logic
        let entryTags: [Tag] = selectedTag.map { convertJournalTagToTag(journalTag: $0) } ?? []
        let moodId = selectedMood?.id ?? ""

        let newEntry = JournalEntry(
            id: UUID(),
            documentId: UUID().uuidString,
            title: title,
            content: content,
            date: Date(),
            moodId: moodId,
            tags: entryTags,
            stoicResponse: nil
        )

        journalViewModel.createJournalEntry(newEntry) { [weak self] error in
            guard let self = self else { return }
            self.isSaving = false
            if let error = error {
                print("Error saving document: \(error)")
            } else {
                print("Journal entry saved successfully")
                self.resetFormFields()
            }
        }
    }

    // Added resetFormFields Method
    private func resetFormFields() {
        self.title = ""
        self.content = ""
        self.selectedTag = nil
        self.selectedMood = nil
    }

    // Additional functions as needed
}

