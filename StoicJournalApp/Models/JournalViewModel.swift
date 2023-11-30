import Foundation
import FirebaseFirestore
import SwiftUI
import FirebaseAuth

class JournalViewModel: ObservableObject {
    @Published var tags: [JournalTag] = []
    @Published var moods: [Mood] = []
    @Published var entries: [JournalEntry] = []

    private let db = Firestore.firestore() // Single Firestore database reference

    init() {
        loadAllData()
    }

    func createOrUpdateJournalEntry(_ entry: JournalEntry, isUpdate: Bool, completion: @escaping (Error?) -> Void) {
        let operation = isUpdate ? "updated" : "created"

        do {
            let data = try Firestore.Encoder().encode(entry)

            if isUpdate {
                guard let documentId = entry.documentId else {
                    completion(NSError(domain: "AppError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Document ID is missing for update."]))
                    return
                }
                db.collection("journalEntries").document(documentId).setData(data) { error in
                    self.handleCompletion(error, entry, operation, isUpdate, completion)
                }
            } else {
                db.collection("journalEntries").addDocument(data: data) { error in
                    self.handleCompletion(error, entry, operation, isUpdate, completion)
                }
            }
        } catch let error {
            completion(error)
        }
    }

    private func handleCompletion(_ error: Error?, _ entry: JournalEntry, _ operation: String, _ isUpdate: Bool, _ completion: @escaping (Error?) -> Void) {
        completion(error)
        if error == nil {
            print("Journal entry \(operation) successfully")
            updateLocalEntries(entry, isUpdate: isUpdate)
        }
    }

    func loadAllData() {
        loadCollection("journalEntries", type: JournalEntry.self) { self.entries = $0 }
        loadCollection("moods", type: Mood.self) { self.moods = $0 }
        loadCollection("tags", type: JournalTag.self, documentToType: { JournalTag(id: $0.documentID, name: $0.get("name") as? String ?? "") }) { self.tags = $0 }
    }

    func loadCollection<T: Decodable>(_ collection: String, type: T.Type, documentToType: ((QueryDocumentSnapshot) -> T)? = nil, completion: @escaping ([T]) -> Void) {
        db.collection(collection).getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents, error == nil else {
                print("Error fetching \(collection): \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            let results: [T] = documents.compactMap { document in
                if let documentToType = documentToType {
                    return documentToType(document)
                } else {
                    return try? document.data(as: type)
                }
            }
            DispatchQueue.main.async {
                completion(results)
                print("Loaded \(collection): \(results)")
            }
        }
    }

    private func updateLocalEntries(_ entry: JournalEntry, isUpdate: Bool) {
        DispatchQueue.main.async {
            if isUpdate, let index = self.entries.firstIndex(where: { $0.documentId == entry.documentId }) {
                self.entries[index] = entry
            } else {
                self.entries.insert(entry, at: 0)
            }
        }
    }

    func deleteJournalEntry(entry: JournalEntry) {
        guard let documentId = entry.documentId else {
            print("Document ID not found for delete operation")
            return
        }

        db.collection("journalEntries").document(documentId).delete { error in
            if let error = error {
                print("Error removing journal entry: \(error)")
            } else {
                self.entries.removeAll { $0.documentId == documentId }
                print("Journal entry deleted successfully")
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
                    print("Error updating journal entry: \(error)")
                } else {
                    if let index = self.entries.firstIndex(where: { $0.documentId == documentId }) {
                        DispatchQueue.main.async {
                            self.entries[index] = entry
                            print("Journal entry updated successfully")
                        }
                    }
                }
            }
        } catch let error {
            print("Error encoding entry for update: \(error)")
        }
    }

    // Additional methods...
}

