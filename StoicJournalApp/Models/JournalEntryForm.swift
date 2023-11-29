import SwiftUI
import Firebase
import Combine

struct JournalEntryForm: View {
    @Binding var title: String
    @Binding var content: String
    @Binding var selectedTag: JournalTag?
    @Binding var selectedMood: Mood?
    
    var tags: [JournalTag]
    var moods: [Mood]
    var journalPrompts: [String] // Array of journal prompts passed directly to the view

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Journal Entry")) {
                    TextField("Title", text: $title)
                    TextEditor(text: $content)
                        .frame(height: 200)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.gray, lineWidth: 1)
                        )

                    Button("Add Random Prompt") {
                        addRandomPrompt()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                
                Section(header: Text("Tags")) {
                    // Debugging: Print the number of tags
                    Text("Number of tags available: \(tags.count)")
                        .foregroundColor(.red)

                    Picker("Select a Tag", selection: $selectedTag) {
                        Text("None").tag(nil as JournalTag?)
                        ForEach(tags, id: \.id) { tag in
                            Text(tag.name).tag(tag as JournalTag?)
                        }
                    }
                }
                
                Section(header: Text("Mood")) {
                    Picker("Select a Mood", selection: $selectedMood) {
                        Text("None").tag(nil as Mood?)
                        ForEach(moods, id: \.id) { mood in
                            HStack {
                                Image(systemName: mood.icon)
                                Text(mood.description)
                            }
                            .tag(mood as Mood?)
                        }
                    }
                }

                // ... other sections ...
            }
            .navigationBarTitle("Journal Entry", displayMode: .inline)
            .onAppear {
                // Debugging: Check if view appeared
                print("JournalEntryForm appeared")
                // Debugging: Print the tags to see if they are being passed correctly
                print("Tags passed to JournalEntryForm: \(tags)")
            }
        }
    }

    private func addRandomPrompt() {
        let randomPrompt = journalPrompts.randomElement() ?? ""
        content += (content.isEmpty ? "" : "\n\n") + randomPrompt
    }
}

// Rest of your code remains the same
