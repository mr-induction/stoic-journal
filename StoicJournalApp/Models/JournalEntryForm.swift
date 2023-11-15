import SwiftUI
import Firebase
import Combine

let allAvailableTags: [JournalTag] = [
    JournalTag(id: "tag1", name: "Personal"),
    JournalTag(id: "tag2", name: "Work"),
    JournalTag(id: "tag3", name: "Travel"),
    // Add more tags as needed
]

let allAvailableMoods: [Mood] = [
    Mood(description: "Happy", icon: "icon1"),
    Mood(description: "Sad", icon: "icon2"),
    Mood(description: "Excited", icon: "icon3"),
    // Add more moods as needed
]

let journalPrompts = [
    "What are you grateful for today?",
    "Describe a challenge you faced and how you overcame it.",
    "What did you learn about yourself today?",
    // Add more prompts as needed
]

struct JournalEntryForm: View {
    @Binding var title: String
    @Binding var content: String
    @Binding var selectedTag: JournalTag?

    var body: some View {
        Form {
            Section(header: Text("Journal Entry")) {
                TextField("Title", text: $title)
                TextEditor(text: $content)
                    .frame(height: 200)
                    .border(Color.gray, width: 1)

                // Button to insert a random prompt
                Button("Add Random Prompt") {
                    addRandomPrompt()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }

            Section(header: Text("Tags")) {
                Picker("Select Tag", selection: $selectedTag) {
                    Text("None").tag(JournalTag?.none)
                    ForEach(allAvailableTags, id: \.id) { tag in
                        Text(tag.name).tag(tag as JournalTag?)
                    }
                }
                .pickerStyle(.menu)
            }

            Button("Save") {
                // Your save logic remains the same
            }
        }
        .onAppear {
            print("JournalEntryForm appeared") // Debugging statement
        }
    }

    private func addRandomPrompt() {
        let randomPrompt = journalPrompts.randomElement() ?? ""
        content += (content.isEmpty ? "" : "\n\n") + randomPrompt
    }
}

struct JournalEntryForm_Previews: PreviewProvider {
    static var previews: some View {
        JournalEntryForm(title: .constant(""), content: .constant(""), selectedTag: .constant(nil))
    }
}

