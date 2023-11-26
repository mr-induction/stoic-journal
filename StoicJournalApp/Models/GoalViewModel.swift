//
//  GoalViewModel.swift
//  StoicJournalApp
//
//  Created by Rin Otori on 11/24/23.
//

import Foundation

class GoalsViewModel: ObservableObject {
    @Published var goals: [Goal] = []
    
    private func deleteGoal(at offsets: IndexSet) {
        offsets.forEach { index in
            if let documentId = goals[index].firestoreDocumentId {
                FirebaseManager.shared.deleteDocument(collectionPath: "goals", documentId: documentId) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success():
                            self.goals.remove(atOffsets: offsets)
                        case .failure(let error):
                            print("Error deleting goal: \(error)")
                        }
                    }
                }
            }
        }
    }
}
