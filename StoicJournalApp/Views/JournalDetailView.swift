import SwiftUI

struct JournalDetailView: View {
    var entry: JournalEntry

    // Define dateFormatter as a static constant to avoid re-creating it every time the view updates
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(entry.title)
                    .font(.largeTitle)
                    .padding(.bottom, 2)
                
                // Use the static dateFormatter here
                Text("Date: \(entry.date, formatter: Self.dateFormatter)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.bottom, 2)
                
                Text(entry.content)
                    .font(.body)
                    .padding(.bottom, 2)
                
                // Optional stoic response
                if let stoicResponse = entry.stoicResponse, !stoicResponse.isEmpty {
                    Text("Stoic Response: \(stoicResponse)")
                        .font(.subheadline)
                        .padding()
                }
            }
            .navigationBarTitle("Entry Details", displayMode: .inline)
        }
    }
}

