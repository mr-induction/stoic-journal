import FirebaseFirestore
import SwiftUI
import FirebaseAuth

struct JournalListView: View {
    @ObservedObject var journalViewModel: JournalViewModel

    var body: some View {
        List {
            ForEach(journalViewModel.entries, id: \.id) { entry in
                NavigationLink(destination: JournalDetailView(entry: entry)) {
                    VStack(alignment: .leading) {
                        Text(entry.title)
                            .font(.headline)
                        Text(entry.content)
                            .font(.subheadline)
                            .lineLimit(1)
                    }
                }
            }
            .onDelete(perform: deleteEntry) // Add the onDelete modifier
        }
        .navigationBarTitle("Saved Entries")
    }

    private func deleteEntry(at offsets: IndexSet) {
        offsets.forEach { index in
            // Assuming you have a method in JournalViewModel to delete an entry
            let entry = journalViewModel.entries[index]
            journalViewModel.deleteJournalEntry(entry: entry)
        }
    }
}
