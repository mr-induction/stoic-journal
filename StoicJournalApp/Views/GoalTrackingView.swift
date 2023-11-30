import SwiftUI

struct GoalTrackingView: View {
    @State private var goals: [Goal] = []
    @State private var showingAddGoalView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(goals) { goal in
                    GoalRowView(goal: Binding(get: {
                        self.goals.first(where: { $0.id == goal.id }) ?? goal
                    }, set: { newValue in
                        if let index = self.goals.firstIndex(where: { $0.id == goal.id }) {
                            self.goals[index] = newValue
                        }
                    }))
                }
                .onDelete(perform: deleteGoal)
            }
            .navigationTitle("Goals")
            .navigationBarItems(trailing: Button(action: {
                self.showingAddGoalView = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddGoalView) {
                AddGoalView(isPresented: $showingAddGoalView, onSave: { newGoal in
                    self.goals.append(newGoal)
                    self.showingAddGoalView = false
                })
            }
            .onAppear {
                loadGoals()
            }
        }
    }
    
    
    
    private func loadGoals() {
        let collectionPath = "goals"
        FirebaseManager.shared.fetchDocuments(collectionPath: collectionPath) { (result: Result<[Goal], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedGoals):
                    print("Before updating goals in loadGoals, count: \(self.goals.count)")
                    self.goals = fetchedGoals
                    print("After updating goals in loadGoals, count: \(self.goals.count)")
                case .failure(let error):
                    print("Error fetching goals: \(error)")
                }
            }
        }
    }
    
    
    private func updateGoal(_ updatedGoal: Goal) {
        guard let documentId = updatedGoal.firestoreDocumentId else {
            return  // Exit the function if there's no document ID
        }
        
        let collectionPath = "goals"
        FirebaseManager.shared.performOperation(.update, collectionPath: collectionPath, documentId: documentId, document: updatedGoal) { result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    print("Before updating goal with documentId \(documentId), goals count: \(self.goals.count)")
                    if let index = self.goals.firstIndex(where: { $0.firestoreDocumentId == documentId }) {
                        self.goals[index] = updatedGoal // Update the goal in the array
                        print("After updating goal at index \(index), goals count: \(self.goals.count)")
                    } else {
                        print("Goal with documentId \(documentId) not found in array.")
                    }
                case .failure(let error):
                    print("Error updating goal: \(error)")
                }
            }
        }
    }
    
    
    
    private func deleteGoal(at offsets: IndexSet) {
        offsets.forEach { index in
            let goalToDelete = goals[index]
            // Convert UUID to String
            let documentId = goalToDelete.id.uuidString
            
            // Delete the goal from Firebase
            FirebaseManager.shared.deleteDocument(collectionPath: "goals", documentId: documentId) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success():
                        self.goals.remove(at: index)
                    case .failure(let error):
                        print("Error deleting goal: \(error)")
                    }
                }
            }
        }
    }
}
