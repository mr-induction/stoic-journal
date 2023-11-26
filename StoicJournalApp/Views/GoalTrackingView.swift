import SwiftUI

struct GoalTrackingView: View {
    @State private var goals: [Goal] = []
    @State private var showingAddGoalView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(goals.indices, id: \.self) { index in
                    GoalRowView(goal: $goals[index])
                        .debugPrint("Index: \(index), Goal: \(goals[index])")
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
                    self.goals = fetchedGoals
                case .failure(let error):
                    print("Error fetching goals: \(error)")
                }
            }
        }
    }
    
    private func updateGoal(_ goal: Goal) {
        guard let documentId = goal.firestoreDocumentId else {
            return  // Exit the function if there's no document ID
        }
        
        let collectionPath = "goals"
        FirebaseManager.shared.performOperation(.update, collectionPath: collectionPath, documentId: documentId, document: goal) { result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    self.loadGoals()  // Reload the goals on successful update
                case .failure(let error):
                    print("Error updating goal: \(error)")
                }
            }
        }
    }
    
    private func deleteGoal(at offsets: IndexSet) {
        for index in offsets.sorted(by: >) {
            if let documentId = goals[index].firestoreDocumentId {
                let collectionPath = "goals"
                
                FirebaseManager.shared.deleteDocument(collectionPath: collectionPath, documentId: documentId) { result in
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
}
