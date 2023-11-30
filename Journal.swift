import SwiftUI

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

struct JournalView: View {
    @State private var activeSheet: ActiveSheet?
    @ObservedObject var journalViewModel: JournalViewModel

    var body: some View {
        NavigationView {
            ZStack {
                Image("stoicbackground")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)

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
                    JournalInputView(journalViewModel: journalViewModel)
                case .viewList:
                    JournalListView(journalViewModel: journalViewModel)
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
