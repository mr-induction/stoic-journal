import SwiftUI

struct HomeView: View {
    @StateObject private var journalViewModel = JournalViewModel()
    @State private var isShowingMenu = false

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    // Background image
                    Image("stoicbackground")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)

                    // Main content
                    mainContent
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .offset(x: isShowingMenu ? 250 : 0)
                        .disabled(isShowingMenu)

                    // Menu button, positioned above all content
                    menuButton
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .topLeading)
                        .padding()

                    // Sliding Menu with transparency, positioned over the content but under the button
                    if isShowingMenu {
                        menuContent
                            .frame(width: 250)
                            .transition(.move(edge: .leading))
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }

    var mainContent: some View {
        VStack {
            Text("StoicScribe")
                .foregroundColor(.white)
                .font(.title)
                .padding(.top)

            Spacer()
        }
    }

    var menuContent: some View {
        VStack(alignment: .leading) {
            NavigationLink(destination: JournalInputView(journalViewModel: journalViewModel)) {
                Text("Journal").padding()
            }
            NavigationLink(destination: GoalTrackingView()) {
                Text("Goal Tracking").padding()
            }
            NavigationLink(destination: DailyQuoteView()) {
                Text("Daily Quote").padding()
            }
            Spacer()
        }
        .background(Color.white.opacity(0.8)) // Transparency added here
        .edgesIgnoringSafeArea(.all)
    }

    var menuButton: some View {
        Button(action: {
            withAnimation {
                isShowingMenu.toggle()
            }
        }) {
            Image(systemName: "line.horizontal.3")
                .imageScale(.large)
                .foregroundColor(.white)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

