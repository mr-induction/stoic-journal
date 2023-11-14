// FirebaseManager.swift
// StoicJournalApp
// Created by Rin Otori on 11/13/23.

import Foundation
import Firebase
import FirebaseFirestore

class FirebaseManager {
    static let shared = FirebaseManager()
    let firestore: Firestore
    
    private init() {
        firestore = Firestore.firestore()
    }
    
    func createJournalEntry(_ journalEntry: JournalEntry, completion: @escaping (Error?) -> Void) {
        var ref: DocumentReference? = nil
        ref = firestore.collection("journalEntries").addDocument(data: [
            "title": journalEntry.title,
            "content": journalEntry.content,
            "date": Timestamp(date: journalEntry.date),
            "moodId": journalEntry.moodId,
            "stoicResponse": journalEntry.stoicResponse // Add Stoic response property
        ]) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    func updateJournalEntry(_ journalEntry: JournalEntry, documentId: String, completion: @escaping (Error?) -> Void) {
        do {
            try firestore.collection("journalEntries").document(documentId).setData(from: journalEntry, completion: completion)
        } catch let error {
            completion(error)
        }
    }
    
    func deleteJournalEntry(documentId: String, completion: @escaping (Error?) -> Void) {
        firestore.collection("journalEntries").document(documentId).delete(completion: completion)
    }
    
    // CRUD operations for Mood
    func createMood(_ mood: Mood, completion: @escaping (Error?) -> Void) {
        do {
            let _ = try firestore.collection("moods").addDocument(from: mood, completion: completion)
        } catch let error {
            completion(error)
        }
    }
    
    func readMoods(completion: @escaping ([Mood]?, Error?) -> Void) {
        firestore.collection("moods").getDocuments { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                completion(nil, error)
                return
            }
            let moods = documents.compactMap { (document) -> Mood? in
                return try? document.data(as: Mood.self)
            }
            completion(moods, nil)
        }
    }
    
    func updateMood(_ mood: Mood, documentId: String, completion: @escaping (Error?) -> Void) {
        do {
            try firestore.collection("moods").document(documentId).setData(from: mood, completion: completion)
        } catch let error {
            completion(error)
        }
    }
    
    func deleteMood(documentId: String, completion: @escaping (Error?) -> Void) {
        firestore.collection("moods").document(documentId).delete(completion: completion)
    }
    
}
