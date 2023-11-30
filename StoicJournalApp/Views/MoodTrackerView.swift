import SwiftUI

struct MoodTrackerView: View {
    @ObservedObject var viewModel: MoodTrackerViewModel

    var body: some View {
        VStack {
            // Display mood options
            List(viewModel.moods, id: \.self) { mood in
                HStack {
                    Image(systemName: mood.icon)
                    Text(mood.description)
                    Spacer()
                    // Show a checkmark next to the selected mood
                    if viewModel.selectedMoodId == mood.id {
                        Image(systemName: "checkmark")
                    }
                }
                .onTapGesture {
                    // Update the selected mood ID when tapped
                    viewModel.selectedMoodId = mood.id
                }
            }
            
            // Save button
            Button(action: {
                // Save the selected mood
                viewModel.saveMood()
            }) {
                Text("Save Mood")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
            }
            .disabled(viewModel.selectedMoodId == nil) // Disable the button if no mood is selected
        }
        .navigationTitle("Track Your Mood")
    }
}
