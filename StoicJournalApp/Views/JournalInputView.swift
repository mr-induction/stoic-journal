import SwiftUI

struct JournalInputView: View {
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var selectedTag: JournalTag? = nil
    @State private var selectedMood: Mood? = nil
    @State private var showConfirmationAlert = false
    @State private var isSaving = false
    @ObservedObject var journalViewModel: JournalViewModel
    
    // Define a static array of journal prompts
    private let journalPrompts = [
        "What are you grateful for today?",
        "Reflect on a happy memory.",
        "What did you learn today?"
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                JournalEntryForm(
                    title: $title,
                    content: $content,
                    selectedTag: $selectedTag,
                    selectedMood: $selectedMood,
                    tags: journalViewModel.tags,
                    moods: journalViewModel.moods,
                    journalPrompts: journalPrompts // Pass the static array of journal prompts
                )
                saveButton
                viewEntriesButton
            }
            .navigationBarTitle("Journal Entry", displayMode: .inline)
            .alert(isPresented: $showConfirmationAlert) {
                Alert(
                    title: Text("Entry Saved"),
                    message: Text("Your journal entry has been saved successfully."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private var saveButton: some View {
        Button("Save Entry") {
            saveJournalEntry()
        }
        .padding()
        .background(isSaving ? Color.gray : Color.green)
        .foregroundColor(.white)
        .cornerRadius(10)
        .disabled(isSaving)
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
    
    private func saveJournalEntry() {
        self.isSaving = true
        
        // Create an array of 'JournalTag' objects from the optionally selected 'JournalTag'.
        let entryTags: [Tag] = convertJournalTagToTag(journalTag: selectedTag)

        // Use the selected mood's ID or an empty string if no mood is selected
        let moodId = selectedMood?.id ?? ""
        
        // Create a new JournalEntry with the user's input
        let newEntry = JournalEntry(
            id: UUID(),
            documentId: UUID().uuidString, // Generate a unique document ID
            title: title, // Use the title entered by the user
            content: content, // Use the content entered by the user
            date: Date(), // Use the current date and time
            moodId: moodId, // Use the selected mood ID
            tags: entryTags, // Use the array of 'Tag' created from the selected JournalTag
            stoicResponse: nil // No stoic response when creating the entry
        )
        
        // Save the new entry using the journalViewModel
        journalViewModel.createJournalEntry(newEntry) { error in
            self.isSaving = false
            if let error = error {
                print("Error saving document: \(error)")
            } else {
                self.showConfirmationAlert = true
                // Clear the form fields after saving
                self.title = ""
                self.content = ""
                self.selectedTag = nil
                self.selectedMood = nil
            }
        }
    }
}
