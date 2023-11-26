import SwiftUI

struct JournalTag: Codable, Hashable {
    let id: String
    let name: String
}

struct TagPickerView: View {
    @Binding var selectedTag: JournalTag?
    var allAvailableTags: [JournalTag] // The array of available tags

    var body: some View {
        Picker("Select Tag", selection: $selectedTag) {
            // Default option for selecting no tag
            Text("None").tag(nil as JournalTag?)

            // Iterate through available tags and create picker options
            ForEach(allAvailableTags, id: \.id) { tag in
                Text(tag.name).tag(tag as JournalTag?)
            }
        }
        .pickerStyle(.menu) // Style the picker as a menu
    }
}

// Sample Preview Provider
struct TagPickerView_Previews: PreviewProvider {
    static var previews: some View {
        TagPickerView(selectedTag: .constant(nil), allAvailableTags: [
            JournalTag(id: "tag1", name: "Personal"),
            JournalTag(id: "tag2", name: "Work"),
            JournalTag(id: "tag3", name: "Travel")
        ])
    }
}

