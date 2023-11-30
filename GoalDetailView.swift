import SwiftUI

struct GoalDetailView: View {
    @Binding var goal: Goal?
    var onSave: (Goal) -> Void

    @State private var editableTitle: String = ""
    @State private var editableDescription: String = ""
    @State private var editableProgress: Double = 0

    // Add Environment variable for presentation mode
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
        }
        .onChange(of: goal) { newValue in
            // If goal becomes nil, dismiss the view
            if newValue == nil {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

// Make sure the Goal struct conforms to Equatable if it doesn't already
extension Goal: Equatable {
    static func == (lhs: Goal, rhs: Goal) -> Bool {
        return lhs.id == rhs.id
    }
}

