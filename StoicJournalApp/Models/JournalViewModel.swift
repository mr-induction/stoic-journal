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
                let _ = try db.collection("journalEntries").addDocument(from: entry, completion: { (error: Error?) in
                    completion(error)
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

                    // Now the check for empty array doesn't need conditional binding
                    if !self.entries.isEmpty {
                        print("Fetched \(self.entries.count) entries")
                    } else {
                        print("No entries found")
                    }
                }
            }
    }




    func loadMoods() {
        // Load moods from Firebase or local data
        // Example moods, replace with actual mood data from Firebase if needed
        moods = [
            Mood(id: "1", icon: "smiley", description: "Happy"),
            Mood(id: "2", icon: "frown", description: "Sad"),
            // Add more moods as needed
        ]
    }

    // New function to load tags
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

                    // Debug print
                    print("Loaded tags: \(self.tags)")
                }
            }
    }


    func deleteJournalEntry(entry: JournalEntry) {
        guard let documentId = entry.documentId else {
            print("Document ID not found")
            return
        }

        db.collection("journalEntries").document(documentId).delete { [weak self] error in
            guard let self = self else { return }

            if let error = error {
                print("Error removing journal entry: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.entries.removeAll { $0.documentId == documentId }
                }
            }
        }
    }

    func saveMood(moodId: String) {
        guard let mood = moods.first(where: { $0.id == moodId }) else { return }
        let userId = Auth.auth().currentUser?.uid ?? "unknown"

        let moodData: [String: Any] = [
            "userId": userId,
            "moodDescription": mood.description,
            "moodIcon": mood.icon,
            "timestamp": Timestamp(date: Date())
        ]

        db.collection("moodEntries").addDocument(data: moodData) { error in
            if let error = error {
                print("Error saving mood: \(error.localizedDescription)")
            } else {
                print("Mood saved successfully")
            }
        }
    }
}

