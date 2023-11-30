import SwiftUI

struct GoalRowView: View {
    @Binding var goal: Goal

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(goal.title)
                    .font(.headline)
                Spacer()
                if goal.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            Text(goal.description)
                .font(.subheadline)
            ProgressView(value: goal.progress)

            if let milestones = goal.milestones {
                ForEach(milestones.indices, id: \.self) { index in
                    HStack {
                        Image(systemName: milestones[index].isCompleted ? "checkmark.square" : "square")
                            .onTapGesture {
                                toggleMilestoneCompletion(at: index)
                            }
                        Text(milestones[index].description)
                    }
                }
            }

            if goal.isCompleted {
                Text("Goal Completed 🎉")
                    .foregroundColor(.green)
                    .bold()
            }
        }
    }

    private func toggleMilestoneCompletion(at index: Int) {
           // Safely unwrap milestones and check the index
           if var milestones = goal.milestones, milestones.indices.contains(index) {
               milestones[index].isCompleted.toggle()
               goal.milestones = milestones  // Reassign to the binding to trigger an update
           }
       }
   }

extension Goal {
    var isCompleted: Bool {
        milestones?.allSatisfy { $0.isCompleted } ?? false
    }
}
