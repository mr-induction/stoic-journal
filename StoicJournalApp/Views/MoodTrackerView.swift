//
//  MoodTrackerView.swift
//  StoicJournalApp
//
//  Created by Rin Otori on 11/19/23.
//

import SwiftUI

struct MoodTrackerView: View {
    @ObservedObject var journalViewModel: JournalViewModel
    @State private var selectedMoodId: String = "" // State for tracking the selected mood ID

    var body: some View {
        VStack {
            Text("How are you feeling today?")
                .font(.title) // Title for the mood tracker
            
            // ScrollView to display mood options horizontally
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    // Loop through each mood in the JournalViewModel
                    ForEach(journalViewModel.moods) { mood in
                        Button(action: {
                            self.selectedMoodId = mood.id // Set the selected mood ID
                        }) {
                            Image(systemName: mood.icon) // Display the mood's icon
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50) // Size of the mood icon
                                .padding()
                                .background(selectedMoodId == mood.id ? Color.gray : Color.clear) // Highlight the selected mood
                                .cornerRadius(25) // Rounded corners for the mood button
                        }
                    }
                }
            }

            // Button to save the selected mood
            Button("Save Mood") {
                journalViewModel.saveMood(moodId: selectedMoodId) // Call the save function in the JournalViewModel
            }
            .disabled(selectedMoodId.isEmpty) // Disable the button if no mood is selected
        }
        .padding() // Padding around the VStack content
    }
}

struct MoodTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        MoodTrackerView(journalViewModel: JournalViewModel()) // Provide a JournalViewModel for the preview
    }
}
