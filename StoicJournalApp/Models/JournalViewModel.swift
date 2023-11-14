//
//  JournalViewModel.swift
//  StoicJournalApp
//
//  Created by Rin Otori on 11/14/23.
//

import Foundation
import FirebaseFirestore
import SwiftUI
import FirebaseAuth

class JournalViewModel: ObservableObject {
    @Published var entries: [JournalEntry] = []
    private let db = Firestore.firestore()
    
    init() {
        loadEntries()
    }
    
    func loadEntries() {
        let userId = Auth.auth().currentUser?.uid ?? "unknown" // Replace with your method of obtaining userId
        
        db.collection("journalEntries").order(by: "date", descending: true).addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents found")
                return
            }
            
            self.entries = documents.compactMap { queryDocumentSnapshot -> JournalEntry? in
                let data = queryDocumentSnapshot.data()
                guard let title = data["title"] as? String,
                      let content = data["content"] as? String,
                      let timestamp = data["date"] as? Timestamp,
                      let moodId = data["moodId"] as? String else {
                    print("Error decoding document: \(queryDocumentSnapshot.documentID)")
                    return nil
                }
                
                let date = timestamp.dateValue()
                let stoicResponse = data["stoicResponse"] as? String ?? "" // Assign a value for stoicResponse
                
                return JournalEntry(title: title, content: content, date: date, moodId: moodId, userId: userId, tags: [], stoicResponse: stoicResponse)
            }
        }
    }

    func deleteJournalEntry(entry: JournalEntry) {
        let entryIdString = entry.id.uuidString // Assuming id is UUID
        
        db.collection("journalEntries").document(entryIdString).delete { error in
            if let error = error {
                print("Error removing journal entry: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.entries.removeAll { $0.id == entry.id }
                }
            }
        }
    }
}
