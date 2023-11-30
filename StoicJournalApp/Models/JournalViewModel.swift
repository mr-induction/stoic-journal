import Foundation
import FirebaseFirestore
import SwiftUI
import FirebaseAuth

class JournalViewModel: ObservableObject {
    @Published var tags: [JournalTag] = []
    @Published var moods: [Mood] = []
    @Published var entries: [JournalEntry] = []

    private let db = Firestore.firestore() // Firestore database reference

    init() {
        loadEntries()
        loadMoods()
        loadTags()
    }

    func createJournalEntry(_ entry: JournalEntry, completion: @escaping (Error?) -> Void) {
        do {
            let _ = try db.collection("journalEntries").addDocument(from: entry, completion: { error in
                completion(error)
                if error == nil {
                    print("Journal entry created successfully")
                }
            })
        } catch let error {
            completion(error)
        }
    }

    func loadEntries() {
        db.collection("journalEntries")
            .order(by: "date", descending: true)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("Error fetching documents: \(error.localizedDescription)")
                    return
                }

                DispatchQueue.main.async {
                    self.entries = querySnapshot?.documents.compactMap { document -> JournalEntry? in
                        do {
                            return try document.data(as: JournalEntry.self)
                        } catch {
                            print("Error decoding document: \(document.documentID), error: \(error)")
                            return nil
                        }
                    } ?? []

                    if !self.entries.isEmpty {
                        print("Fetched \(self.entries.count) entries")
                    } else {
                        print("No entries found")
                    }
                }
            }
    }
    func saveMood(mood: Mood) {
        // Reference to the Firestore database
        let db = Firestore.firestore()

        // Convert the Mood object into a dictionary for Firestore
        let moodData: [String: Any] = [
            "id": mood.id,
          
            // Add other properties of the Mood object here if necessary
        ]

        // Add the mood to the "moods" collection in Firestore
        db.collection("moods").document(mood.id).setData(moodData) { error in
            if let error = error {
                // If there's an error, print it out
                print("Error saving mood: \(error.localizedDescription)")
            } else {
                // If the save is successful, print out a success message
                print("Mood successfully saved")
            }
        }
    }
    func loadMoods() {
        db.collection("moods")
            .getDocuments { [weak self] querySnapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("Error fetching moods: \(error.localizedDescription)")
                    return
                }

                DispatchQueue.main.async {
                    self.moods = querySnapshot?.documents.compactMap { document -> Mood? in
                        try? document.data(as: Mood.self)
                    } ?? []

                    print("Loaded moods: \(self.moods)")
                }
            }
    }

  
    func loadTags() {
            db.collection("tags")
                .getDocuments { [weak self] querySnapshot, error in
                    guard let self = self else { return }

                    if let error = error {
                        print("Error fetching tags: \(error.localizedDescription)")
                        return
                    }

                    DispatchQueue.main.async {
                        self.tags = querySnapshot?.documents.compactMap { document -> JournalTag? in
                            let id = document.documentID
                            let name = document.get("name") as? String ?? ""
                            return JournalTag(id: id, name: name)
                        } ?? []

                        print("Loaded tags: \(self.tags)")
                    }
                }
        }

    func deleteJournalEntry(entry: JournalEntry) {
        guard let documentId = entry.documentId else {
            print("Document ID not found for delete operation")
            return
        }

        db.collection("journalEntries").document(documentId).delete { [weak self] error in
            guard let self = self else { return }

            if let error = error {
                print("Error removing journal entry: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.entries.removeAll { $0.documentId == documentId }
                    print("Journal entry deleted successfully")
                }
            }
        }
    }

    func updateJournalEntry(entry: JournalEntry) {
        guard let documentId = entry.documentId else {
            print("Document ID not found for update operation")
            return
        }

        do {
            let data = try Firestore.Encoder().encode(entry)
            db.collection("journalEntries").document(documentId).setData(data, merge: true) { error in
                if let error = error {
                    print("Error updating journal entry: \(error.localizedDescription)")
                } else {
                    print("Journal entry updated successfully in Firestore")
                    DispatchQueue.main.async {
                        if let index = self.entries.firstIndex(where: { $0.documentId == documentId }) {
                            self.entries[index] = entry
                            print("Journal entry updated successfully in the local array")
                        } else {
                            print("Updated entry not found in the local array")
                        }
                    }
                }
            }
        } catch let error {
            print("Error encoding entry for update: \(error)")
        }
    }

    // Add other methods if any...
}

