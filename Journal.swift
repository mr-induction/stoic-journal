import SwiftUI

struct Journal: View {
    @State private var activeSheet: ActiveSheet?
    @ObservedObject var journalViewModel: JournalViewModel

    // Access the shared instance of FirebaseManager
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
    } // This closing brace was missing
    
    var body: some View {
        NavigationView {
            VStack {
                Button("Add Journal Entry") {
                    activeSheet = .addEntry
                }
                .padding()
                .buttonStyle(PrimaryButtonStyle())
                
                Button("View Journal Entries") {
                    activeSheet = .viewList
                }
                .padding()
                .buttonStyle(PrimaryButtonStyle())
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
