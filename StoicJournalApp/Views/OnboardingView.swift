import SwiftUI

struct OnboardingView: View {
    // State variable to track the current index of the onboarding screen
    @State private var currentIndex: Int = 0

    var body: some View {
        VStack {
            Text("Welcome to StoicJournalApp")
                .font(.largeTitle)
                .padding()

            Image("onboarding-image")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()

            Text("Your personal space for stoic reflections and growth.")
                .font(.headline)
                .padding()

            // Swipe gesture detection
            .gesture(
                DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                    .onEnded { value in
                        if value.translation.width < 0 {
                            // Swiped left: move to the next screen
                            currentIndex = min(currentIndex + 1, 2) // Assuming there are 3 onboarding screens
                        } else if value.translation.width > 0 {
                            // Swiped right: go back to the previous screen
                            currentIndex = max(currentIndex - 1, 0)
                        }
                    }
            )

            // Display different content based on the current index
            if currentIndex == 1 {
                Text("Swipe to learn more")
            } else if currentIndex == 2 {
                Text("Get ready to explore your inner world!")
            }

            Spacer()

            // Button to skip or proceed based on the current index
            Button(action: {
                // Code to proceed to the next part of the app or skip the onboarding
            }) {
                Text(currentIndex == 2 ? "Get Started" : "Skip")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
    }
}

