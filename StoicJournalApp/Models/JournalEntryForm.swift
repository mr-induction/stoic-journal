import SwiftUI
import Firebase
import Combine

struct JournalEntryForm: View {
    @Binding var title: String
    @Binding var content: String
    @Binding var selectedTag: JournalTag?
    @Binding var selectedMood: Mood?
    @ObservedObject var viewModel: MoodTrackerViewModel

    var tags: [JournalTag]
    var journalPrompts: [String] // Array of journal prompts

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Journal Entry")) {
                    TextField("Title", text: $title)
                    TextEditor(text: $content)
                        .frame(minHeight: 200)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray, lineWidth: 1))
                    
                    Button(action: addRandomPrompt) {
                        Text("Add Random Prompt")
                            .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                
                Section(header: Text("Tags")) {
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
                        ForEach(viewModel.moods, id: \.id) { mood in
                            HStack {
                                Image(systemName: mood.icon)
                                Text(mood.description)
                            }.tag(mood as Mood?)
                        }
                    }
                }

                // ... other sections if needed ...
            }
            .navigationBarTitle("Journal Entry", displayMode: .inline)
        }
    }

    private func addRandomPrompt() {
        let randomPrompt = journalPrompts.randomElement() ?? ""
        content += (content.isEmpty ? "" : "\n\n") + randomPrompt
    }
}
