
import SwiftUI


struct ContentView: View {
    // Using @State to track a simple user state - whether the user is logged in or not
    @State private var isLoggedIn: Bool = false

    var body: some View {
        NavigationView {
            // Using a conditional statement to switch views based on user state
            if isLoggedIn {
                HomeView()
            } else {
                VStack {
                    Text("Welcome to StoicJournalApp")
                        .font(.largeTitle)
                        .padding()

                    // NavigationLink provides a way to transition to another view
                    NavigationLink(destination: HomeView()) {
                        Text("Start Journaling")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}
