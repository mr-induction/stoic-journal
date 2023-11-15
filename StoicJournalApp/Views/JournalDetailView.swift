import SwiftUI


struct JournalDetailView: View {
    var entry: JournalEntry

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(entry.title)
                    .font(.largeTitle)
                Text(entry.content)
                    .font(.body)
                // Add Stoic Response here
                Text("Stoic Response: \(entry.stoicResponse)")
                    .font(.subheadline)
                    .padding(.top) // Add padding for visual separation
            }
            .padding()
        }
        .navigationBarTitle("Entry Details", displayMode: .inline)
    }
}



struct JournalEntryDetailView: View {
    var entry: JournalEntry

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(entry.title)
                    .font(.largeTitle)
                    .padding(.bottom, 2)

                Text(entry.content)
                    .font(.body)
                    .padding(.bottom, 2)

                Text("Mood ID: \(entry.moodId)")
                    .font(.subheadline)
                    .padding(.bottom, 2)

                // Display other properties as needed
            }
            .padding()
        }
        .navigationTitle("Entry Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}