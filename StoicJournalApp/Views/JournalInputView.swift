import SwiftUI
import Firebase

struct JournalInputView: View {
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var selectedTag: JournalTag? = nil
    @ObservedObject var journalViewModel = JournalViewModel() // Assuming JournalViewModel exists

    var body: some View {
        NavigationView {
            VStack {
                JournalEntryForm(title: $title, content: $content, selectedTag: $selectedTag)

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
            .navigationBarTitle("Journal Entry", displayMode: .inline)
        }
    }
}

