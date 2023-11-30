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
        isSaving = true

        let entryTags: [Tag] = selectedTag.map { convertJournalTagToTag(journalTag: $0) } ?? []
        let moodId = selectedMood?.id ?? ""

        let newEntry = JournalEntry(
            id: UUID(),
            documentId: nil, // Document ID is nil for new entries
            title: title,
            content: content,
            date: Date(),
            moodId: moodId,
            tags: entryTags,
            stoicResponse: nil
        )

        journalViewModel.createOrUpdateJournalEntry(newEntry, isUpdate: false) { [weak self] error in
            guard let self = self else { return }
            self.isSaving = false
            if let error = error {
                print("Error saving document: \(error.localizedDescription)")
            } else {
                print("Journal entry saved successfully")
                self.resetFormFields()
            }
        }
    }

    private func resetFormFields() {
        title = ""
        content = ""
        selectedTag = nil
        selectedMood = nil
    }

    func updateStoicResponse(stoicResponse: String, for entry: JournalEntry) {
        var updatedEntry = entry
        updatedEntry.stoicResponse = stoicResponse

        journalViewModel.createOrUpdateJournalEntry(updatedEntry, isUpdate: true) { error in
            if let error = error {
                print("Error updating journal entry: \(error.localizedDescription)")
            } else {
                print("Journal entry updated successfully")
            }
        }
    }

    func printCurrentEntry(entry: JournalEntry) {
        print("""
              Entry ID: \(entry.id?.uuidString)
              Title: \(entry.title)
              Content: \(entry.content)
              Stoic Response: \(entry.stoicResponse ?? "No response")
              """)
    }

    // Add here a method to convert JournalTag to Tag if needed
    // func convertJournalTagToTag(journalTag: JournalTag) -> Tag { ... }

    // Additional functions as needed...
}

