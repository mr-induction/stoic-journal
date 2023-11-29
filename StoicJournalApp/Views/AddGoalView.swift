import SwiftUI
import Combine

struct AddGoalView: View {
    @Binding var isPresented: Bool
    var onSave: (Goal) -> Void
    @StateObject var openAIService = OpenAIService()

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var milestones: [String] = []
    @State private var isProcessing = false
    @State private var showError = false
    @State private var cancellables = Set<AnyCancellable>()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Enter goal title", text: $title)
                }

                Section(header: Text("Description")) {
                    TextField("Enter goal description", text: $description)
                }

                Button("Decompose Goal") {
                    decomposeGoal()
                }
                .disabled(title.isEmpty || description.isEmpty)

                if isProcessing {
                    Section {
                        Text("Processing...")
                    }
                } else if !milestones.isEmpty {
                    Section(header: Text("Milestones")) {
                        ForEach(milestones, id: \.self) { milestone in
                            Text(milestone)
                        }
                    }
                }
            }
            .navigationBarTitle("Add New Goal", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                },
                trailing: Button("Save") {
                    let newGoal = Goal(title: title, description: description,
                                       milestones: milestones.map { Goal.Milestone(description: $0, isCompleted: false) })
                    print("Saving Goal: \(newGoal)")

                    // Call FirebaseManager to save the newGoal.
                    FirebaseManager.shared.performOperation(.create, collectionPath: "goals", document: newGoal) { result in
                        switch result {
                        case .success:
                            print("Goal saved")
                            onSave(newGoal) // Call the onSave closure with the new goal.
                            isPresented = false // Dismiss the AddGoalView.
                        case .failure(let error):
                            print("Error saving goal: \(error.localizedDescription)")
                            showError = true // Show error message to the user.
                        }
                    }
                }
                .disabled(milestones.isEmpty)
            )
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text("Failed to save your goal."), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func decomposeGoal() {
        guard !title.isEmpty && !description.isEmpty else { return }

        isProcessing = true
        milestones = []

        openAIService.decomposeGoal(from: title + ": " + description)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                isProcessing = false
                if case .failure = completion {
                    showError = true
                    print("Error in decomposing goal")
                }
            }, receiveValue: { decomposedMilestones in
                self.milestones = decomposedMilestones
                print("Received milestones: \(decomposedMilestones)")
            })
            .store(in: &cancellables)
    }
}
