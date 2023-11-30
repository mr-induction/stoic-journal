import SwiftUI

struct JournalInputView: View {
    @StateObject private var entryViewModel: JournalEntryViewModel
    @State private var showConfirmationAlert: Bool = false
    @ObservedObject var journalViewModel: JournalViewModel

    // Define a static array of journal prompts
    private let journalPrompts = [
        "What are you grateful for today?",
        "Reflect on a happy memory.",
        "What did you learn today?"
    ]

    init(journalViewModel: JournalViewModel) {
        _journalViewModel = ObservedObject(wrappedValue: journalViewModel)
        _entryViewModel = StateObject(wrappedValue: JournalEntryViewModel(journalViewModel: journalViewModel))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                JournalEntryForm(
                    title: $entryViewModel.title,
                    content: $entryViewModel.content,
                    selectedTag: $entryViewModel.selectedTag,
                    selectedMood: $entryViewModel.selectedMood,
                    tags: journalViewModel.tags,
                    moods: journalViewModel.moods,
                    journalPrompts: journalPrompts
                )
                SaveButtonView(isLoading: $entryViewModel.isSaving) {
                    entryViewModel.saveJournalEntry()
                }
                .padding()
                viewEntriesButton
            }
            .navigationBarTitle("", displayMode: .inline)
            .alert(isPresented: $showConfirmationAlert) {
                Alert(
                    title: Text("Entry Saved"),
                    message: Text("Your journal entry has been saved successfully."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .onReceive(entryViewModel.$isSaving) { isSaving in
            showConfirmationAlert = !isSaving && !entryViewModel.title.isEmpty
        }
    }
    
    private var viewEntriesButton: some View {
        NavigationLink(destination: JournalListView(journalViewModel: journalViewModel)) {
            Text("View Saved Entries")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding()
    }
}

