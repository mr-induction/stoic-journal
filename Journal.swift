import SwiftUI

struct JournalView: View {
    @State private var activeSheet: ActiveSheet?
    @ObservedObject var journalViewModel: JournalViewModel

    private var firebaseManager = FirebaseManager.shared

    enum ActiveSheet: Identifiable {
        case addEntry, viewList

        var id: Int {
            switch self {
            case .addEntry:
                return 0
            case .viewList:
                return 1
            }
        }
    }

    init(journalViewModel: JournalViewModel) {
        self.journalViewModel = journalViewModel
    }

    var body: some View {
        ZStack {
            // Background image
            Image("stoicbackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)

            // Main content
            NavigationView {
                VStack {
                    Button("Add Journal Entry") {
                        activeSheet = .addEntry
                    }
                    .padding()
                    .buttonStyle(PrimaryButtonStyle())

                    // Other content goes here
                }
                .navigationBarTitle("Journal Entries")
            }
            .sheet(item: $activeSheet) { item in
                switch item {
                case .addEntry:
                    JournalInputView(journalViewModel: journalViewModel) // Pass the existing journalViewModel instance
                case .viewList:
                    JournalListView(journalViewModel: journalViewModel) // Pass the existing journalViewModel instance
                }
            }
        }
    }
}

struct JournalView_Previews: PreviewProvider {
    static var previews: some View {
        JournalView(journalViewModel: JournalViewModel())
    }
}
