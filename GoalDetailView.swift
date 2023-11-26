import SwiftUI

struct GoalDetailView: View {
    @Binding var goal: Goal?
    var onSave: (Goal) -> Void
    
    @State private var editableTitle: String = ""
    @State private var editableDescription: String = ""
    @State private var editableProgress: Double = 0
    
    var body: some View {
        NavigationView {
            Form {
                if let goal = goal {
                    TextField("Title", text: $editableTitle)
                    TextField("Description", text: $editableDescription)
                    Slider(value: $editableProgress, in: 0...1, step: 0.1)
                        .onAppear {
                            // Debugging: Print the value of editableProgress
                            print("editableProgress: \(editableProgress)")
                        }
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
        }
    }
}

