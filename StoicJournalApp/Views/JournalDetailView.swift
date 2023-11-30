import SwiftUI

struct JournalDetailView: View {
    @ObservedObject var journalViewModel: JournalViewModel
    var entryIndex: Int // Index of the entry in the JournalViewModel's entries array

    // Computed property to bind to the journal entry
    private var entryBinding: Binding<JournalEntry> {
        Binding(
            get: { self.journalViewModel.entries[self.entryIndex] },
            set: { self.journalViewModel.entries[self.entryIndex] = $0 }
        )
    }

    @StateObject private var viewModel = JournalDetailViewModel()

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(entryBinding.wrappedValue.title)
                    .font(.largeTitle)
                    .padding(.bottom, 2)

                Text("Date: \(entryBinding.wrappedValue.date, formatter: Self.dateFormatter)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.bottom, 2)

                Text(entryBinding.wrappedValue.content)
                    .font(.body)
                    .padding(.bottom, 2)

                if viewModel.isLoading {
                    ProgressView()
                } else {
                    if let response = entryBinding.wrappedValue.stoicResponse {
                        Text("Stoic Response: \(response)")
                            .font(.subheadline)
                            .padding()
                    }
                }

                Button("Generate Stoic Commentary") {
                    viewModel.generateStoicCommentary(for: entryBinding.wrappedValue.content) { response in
                        var updatedEntry = entryBinding.wrappedValue
                        updatedEntry.stoicResponse = response
                        entryBinding.wrappedValue = updatedEntry
                    }
                }
                .padding()

                Button("Save Changes") {
                    saveUpdatedEntry()
                }
                .padding()
            }
            .navigationBarTitle("Entry Details", displayMode: .inline)
        }
    }

    private func saveUpdatedEntry() {
        journalViewModel.updateJournalEntry(entry: entryBinding.wrappedValue)
    }
}

