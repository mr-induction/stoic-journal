import SwiftUI

struct JournalDetailView: View {
    var entry: JournalEntry
    @StateObject private var viewModel = JournalDetailViewModel()

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

                Text("Date: \(entry.date, formatter: Self.dateFormatter)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.bottom, 2)

                Text(entry.content)
                    .font(.body)
                    .padding(.bottom, 2)

                Button(action: {
                    viewModel.generateStoicCommentary(for: entry.content)
                }) {
                    Text("Generate Stoic Commentary")
                }
                .padding()

                if viewModel.isLoading {
                    ProgressView()
                }

                if let response = viewModel.stoicResponse {
                    Text("Stoic Response: \(response)")
                        .font(.subheadline)
                        .padding()
                }
            }
            .navigationBarTitle("Entry Details", displayMode: .inline)
        }
    }
}
