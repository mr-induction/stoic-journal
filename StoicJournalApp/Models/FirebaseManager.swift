import Foundation
import Firebase
import FirebaseFirestore

class FirebaseManager {
    
    static let shared = FirebaseManager()
    private let firestore = Firestore.firestore()

    enum FirestoreOperation {
        case create, read, update, delete
    }

    enum FirebaseError: Error {
        case missingDocument
        case operationNotSupported
        // ... other error cases
    }

    // This function performs CRUD operations on Firestore
    func performOperation<T: Encodable>(_ operation: FirestoreOperation, collectionPath: String, documentId: String? = nil, document: T? = nil, completion: @escaping (Result<Void, Error>) -> Void) {
            let reference = firestore.collection(collectionPath)
            
            switch operation {
            case .create:
                guard let document = document else {
                    completion(.failure(FirebaseError.missingDocument))
                    return
                }
                do {
                    print("Creating document: \(document)")
                    let _ = try reference.addDocument(from: document) { error in
                        if let error = error {
                            print("Error performing create operation: \(error.localizedDescription)")
                            completion(.failure(error))
                        } else {
                            print("Successfully created document with data: \(document)")
                            completion(.success(()))
                        }
                    }
                } catch {
                    print("Error serializing document: \(error.localizedDescription)")
                    completion(.failure(error))
                }
                
            case .read:
                // Read operation should be handled by a separate function that returns the expected data type.
                break
                
            case .update:
                guard let documentId = documentId, let document = document else {
                    completion(.failure(FirebaseError.missingDocument))
                    return
                }
                do {
                    print("Updating document ID: \(documentId) with data: \(document)")
                    let _ = try reference.document(documentId).setData(from: document) { error in
                        if let error = error {
                            print("Error performing update operation: \(error.localizedDescription)")
                            completion(.failure(error))
                        } else {
                            print("Successfully updated document ID: \(documentId) with data: \(document)")
                            completion(.success(()))
                        }
                    }
                } catch {
                    print("Error serializing document for update: \(error.localizedDescription)")
                    completion(.failure(error))
                }
                
            case .delete:
                guard let documentId = documentId else {
                    completion(.failure(FirebaseError.missingDocument))
                    return
                }
                print("Deleting document ID: \(documentId)")
                reference.document(documentId).delete { error in
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
        
        func fetchDocuments<U: Decodable>(collectionPath: String, completion: @escaping (Result<[U], Error>) -> Void) {
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
                    print("No documents found.")
                    completion(.success([]))
                }
            }
        }
        
        func deleteDocument(collectionPath: String, documentId: String, completion: @escaping (Result<Void, Error>) -> Void) {
            let documentReference = firestore.collection(collectionPath).document(documentId)
            print("Deleting document ID: \(documentId)")
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
