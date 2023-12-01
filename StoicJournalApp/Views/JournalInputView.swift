import SwiftUI

struct JournalInputView: View {
    @StateObject private var entryViewModel: JournalEntryViewModel
    @State private var showConfirmationAlert: Bool = false
    @ObservedObject var journalViewModel: JournalViewModel
    
    @StateObject private var moodTrackerViewModel = MoodTrackerViewModel()
    private let journalPrompts = ["What are you grateful for today?", "Reflect on a happy memory.", "What did you learn today?"]

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
                    viewModel: moodTrackerViewModel,
                    tags: journalViewModel.tags,
                    journalPrompts: journalPrompts
                )
                SaveButtonView(isLoading: $entryViewModel.isSaving) {
                    entryViewModel.saveJournalEntry()
                }
                .padding()
                viewEntriesButton
            }
            .background(
                Image("stoicbackground") // Make sure this image name matches exactly with the one in your asset catalog
                    .resizable()
                    .scaledToFill()
                    .opacity(0.3)
            )
            .navigationBarTitle("", displayMode: .inline)
            .alert(isPresented: $showConfirmationAlert) {
                Alert(title: Text("Entry Saved"), message: Text("Your journal entry has been saved successfully."), dismissButton: .default(Text("OK")))
            }
        }
        .edgesIgnoringSafeArea(.all) // This will allow the background to extend under the navigation bar
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

