import SwiftUI

struct JournalDetailView: View {
    var entry: JournalEntry

    // Define dateFormatter here
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(entry.title)
                    .font(.largeTitle)
                    .padding(.bottom, 2)

                // Use dateFormatter here
                Text("Date: \(entry.date, formatter: dateFormatter)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.bottom, 2)

                Text(entry.content)
                    .font(.body)
                    .padding(.bottom, 2)

                Text("Stoic Response: \(entry.stoicResponse)")
                    .font(.subheadline)
                    .padding(.top)
            }
            .padding()
        }
        .navigationBarTitle("Entry Details", displayMode: .inline)
    }
}


    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }

struct JournalEntryDetailView: View {
    var entry: JournalEntry
    
    // Define dateFormatter here
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(entry.title)
                    .font(.largeTitle)
                    .padding(.bottom, 2)
                
                // Use dateFormatter here
                Text("Date: \(entry.date, formatter: dateFormatter)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.bottom, 2)
                
                Text(entry.content)
                    .font(.body)
                    .padding(.bottom, 2)
                
                Text("Mood ID: \(entry.moodId)")
                    .font(.subheadline)
                    .padding(.bottom, 2)
                
                Text("Stoic Response: \(entry.stoicResponse)")
                    .font(.subheadline)
                
            }
        }
    }
}
