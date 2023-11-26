//
//  GoalRowView.swift
//  StoicJournalApp
//
//  Created by Rin Otori on 11/20/23.
//

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

            // Handling optional milestones
            if let milestonesBinding = Binding($goal.milestones) {
                ForEach(milestonesBinding) { $milestone in
                    HStack {
                        Image(systemName: milestone.isCompleted ? "checkmark.square" : "square")
                            .onTapGesture {
                                milestone.isCompleted.toggle()
                            }
                        Text(milestone.description)
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
}

extension Goal {
    var isCompleted: Bool {
        milestones?.allSatisfy { $0.isCompleted } ?? false
    }
}
