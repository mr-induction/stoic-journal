import SwiftUI
import Combine  // Needed for using Combine

struct AddGoalView: View {
    @Binding var isPresented: Bool
    var onSave: (Goal) -> Void
    @StateObject var openAIService = OpenAIService()  // Instance of OpenAIService, use @StateObject for ownership

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var milestones: [String] = []
    @State private var isProcessing = false
    @State private var showError = false
    @State private var cancellables = Set<AnyCancellable>()  // For Combine cancellables
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
                    let newGoal = Goal(title: title, description: description, milestones: milestones.map { Goal.Milestone(description: $0, isCompleted: false) })
                    onSave(newGoal)
                    isPresented = false
                }
                .disabled(milestones.isEmpty)
            )
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text("Failed to process your goal."), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func decomposeGoal() {
        guard !title.isEmpty && !description.isEmpty else { return }

        isProcessing = true
        milestones = []

        // Call the decomposeGoal function correctly
        openAIService.decomposeGoal(from: title + ": " + description)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                isProcessing = false
                if case .failure = completion {
                    showError = true
                }
            }, receiveValue: { decomposedMilestones in
                self.milestones = decomposedMilestones
            })
            .store(in: &cancellables)
    }
}
