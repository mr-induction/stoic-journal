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
                
                // Simply remove userId from the call
                return JournalEntry(documentId: queryDocumentSnapshot.documentID, title: title, content: content, date: date, moodId: moodId, tags: [], stoicResponse: stoicResponse)
            }
        }
    }
    
    func deleteJournalEntry(entry: JournalEntry) {
        guard let documentId = entry.documentId else {
            print("Document ID not found")
            return
        }
        
        db.collection("journalEntries").document(documentId).delete { error in
            if let error = error {
                print("Error removing journal entry: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.entries.removeAll { $0.documentId == documentId }
                }
            }
        }
    }
}
