import SwiftUI

struct GoalDetailView: View {
    @Binding var goal: Goal?
    var onSave: (Goal) -> Void

    @State private var editableTitle: String = ""
    @State private var editableDescription: String = ""
    @State private var editableProgress: Double = 0

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                if let goal = goal {
                    TextField("Title", text: $editableTitle)
                    TextField("Description", text: $editableDescription)
                    Slider(value: $editableProgress, in: 0...1, step: 0.1)
                    Button("Save Changes") {
                        let updatedGoal = Goal(
                            id: goal.id,
                            firestoreDocumentId: goal.firestoreDocumentId,
                            title: editableTitle,
                            description: editableDescription,
                            milestones: goal.milestones
                        )
                        onSave(updatedGoal)
                        self.goal = nil
                    }
                }
            }
            .navigationTitle("Edit Goal")
        }
        .onAppear {
            if let goal = goal {
                editableTitle = goal.title
                editableDescription = goal.description
                // Assuming progress is calculated as a fraction
                editableProgress = goal.progress
            }
        }
        .onChange(of: goal) { _ in
            presentationMode.wrappedValue.dismiss()
        }
    }
}

// Make sure the Goal struct conforms to Equatable if it doesn't already
extension Goal: Equatable {
    static func == (lhs: Goal, rhs: Goal) -> Bool {
        return lhs.id == rhs.id
    }
}

