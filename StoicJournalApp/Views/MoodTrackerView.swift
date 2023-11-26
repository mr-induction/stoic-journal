//
//  MoodTrackerView.swift
//  StoicJournalApp
//
//  Created by Rin Otori on 11/19/23.
//

import SwiftUI

struct MoodTrackerView: View {
    @ObservedObject var journalViewModel: JournalViewModel
    @State private var selectedMoodId: String = ""

    var body: some View {
        VStack {
            Text("How are you feeling today?")
                .font(.title)
            
            // Display mood options
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(journalViewModel.moods) { mood in
                        Button(action: {
                            self.selectedMoodId = mood.id
                        }) {
                            Image(systemName: mood.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .padding()
                                .background(selectedMoodId == mood.id ? Color.gray : Color.clear)
                                .cornerRadius(25)
                        }
                    }
                }
            }

            Button("Save Mood") {
                journalViewModel.saveMood(moodId: selectedMoodId)
            }
            .disabled(selectedMoodId.isEmpty)
        }
        .padding()
    }
}


struct MoodTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        MoodTrackerView(journalViewModel: JournalViewModel())
    }
}
