import SwiftUI

struct HomeView: View {
    @StateObject private var journalViewModel = JournalViewModel()

    var body: some View {
        TabView {
            Journal(journalViewModel: journalViewModel)
                .tabItem {
                    Label("Journal", systemImage: "book.fill")
                }

            MoodTrackerView(journalViewModel: journalViewModel)
                .tabItem {
                    Label("Mood Tracker", systemImage: "waveform.path.ecg")
                }

            GoalTrackingView()
                .tabItem {
                    Label("Goals", systemImage: "target")
                }

            DailyQuoteView()
                .tabItem {
                    Label("Daily Quote", systemImage: "quote.bubble")
                }

            // Add more tabs as needed for other features
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
