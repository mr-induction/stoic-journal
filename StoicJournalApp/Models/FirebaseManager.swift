import Foundation
import Firebase
import FirebaseFirestore

class FirebaseManager {
    
    static let shared = FirebaseManager()
    private let firestore = Firestore.firestore()

    enum FirestoreOperation {
        case create, update, delete
        // Removed 'read' as it's handled by fetchDocuments
    }

    enum FirebaseError: Error {
        case missingDocument
        case operationNotSupported
        // ... other error cases
    }

    // Function for CRUD operations on Firestore
    func performOperation<T: Encodable>(_ operation: FirestoreOperation, collectionPath: String, documentId: String? = nil, document: T? = nil, completion: @escaping (Result<Void, Error>) -> Void) {
        let reference = firestore.collection(collectionPath)
        
        switch operation {
        case .create:
            guard let document = document else {
                print("Error: Document missing for creation.")
                completion(.failure(FirebaseError.missingDocument))
                return
            }
            do {
                print("Attempting to create document in collection \(collectionPath): \(document)")
                let _ = try reference.addDocument(from: document) { error in
                    if let error = error {
                        print("Error during creation: \(error.localizedDescription)")
                        completion(.failure(error))
                    } else {
                        print("Document creation successful.")
                        completion(.success(()))
                    }
                }
            } catch {
                print("Error serializing document for creation: \(error.localizedDescription)")
                completion(.failure(error))
            }
            
        case .update:
            guard let documentId = documentId, let document = document else {
                print("Error: Document or Document ID missing for update.")
                completion(.failure(FirebaseError.missingDocument))
                return
            }
            do {
                print("Attempting to update document with ID \(documentId) in collection \(collectionPath): \(document)")
                let _ = try reference.document(documentId).setData(from: document) { error in
                    if let error = error {
                        print("Error during update: \(error.localizedDescription)")
                        completion(.failure(error))
                    } else {
                        print("Document update successful.")
                        completion(.success(()))
                    }
                }
            } catch {
                print("Error serializing document for update: \(error.localizedDescription)")
                completion(.failure(error))
            }
            
        case .delete:
            guard let documentId = documentId else {
                print("Error: Document ID missing for deletion.")
                completion(.failure(FirebaseError.missingDocument))
                return
            }
            print("Attempting to delete document with ID \(documentId) from collection \(collectionPath).")
            reference.document(documentId).delete { error in
                if let error = error {
                    print("Error during deletion: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    print("Document deletion successful.")
                    completion(.success(()))
                }
            }
        }
    }

    // Function to fetch documents from Firestore
    func fetchDocuments<U: Decodable>(collectionPath: String, completion: @escaping (Result<[U], Error>) -> Void) {
        print("Fetching documents from collection: \(collectionPath)")
        let reference = firestore.collection(collectionPath)
        reference.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
                completion(.failure(error))
            } else if let snapshot = snapshot {
                do {
                    let documents = try snapshot.documents.compactMap {
                        try $0.data(as: U.self)
                    }
                    print("Successfully fetched documents: \(documents)")
                    completion(.success(documents))
                } catch {
                    print("Error decoding documents: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            } else {
                print("No documents found in collection \(collectionPath).")
                completion(.success([]))
            }
        }
    }

    // Function to delete a document from Firestore
    func deleteDocument(collectionPath: String, documentId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        print("Attempting to delete document with ID \(documentId) from collection \(collectionPath).")
        let documentReference = firestore.collection(collectionPath).document(documentId)
        documentReference.delete { error in
            if let error = error {
                print("Error performing delete operation: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("Successfully deleted document ID: \(documentId)")
                completion(.success(()))
            }
        }
    }
}

