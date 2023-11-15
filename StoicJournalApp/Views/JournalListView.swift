import FirebaseFirestore
import SwiftUI
import FirebaseAuth

struct JournalListView: View {
    @ObservedObject var journalViewModel: JournalViewModel

    // DateFormatter to format the date for display
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }

    var body: some View {
        List {
            ForEach(journalViewModel.entries, id: \.id) { entry in
                NavigationLink(destination: JournalDetailView(entry: entry)) {
                    VStack(alignment: .leading) {
                        Text(entry.title)
                            .font(.headline)
                        
                        // Add the formatted date here
                        Text(entry.date, formatter: dateFormatter)
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        Text(entry.content)
                            .font(.subheadline)
                            .lineLimit(1)
                    }
                }
            }
            .onDelete(perform: deleteEntry)
        }
        .navigationBarTitle("Saved Entries")
    }

    private func deleteEntry(at offsets: IndexSet) {
        offsets.forEach { index in
            let entry = journalViewModel.entries[index]
            journalViewModel.deleteJournalEntry(entry: entry)
        }
    }
}
