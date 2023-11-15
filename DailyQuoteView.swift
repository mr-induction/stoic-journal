import SwiftUI

struct DailyQuoteView: View {
    // Assuming the quote and author are stored in constant String variables for simplicity.
    // In a real app, we might fetch these from a server or local database.
    let quote: String = "Waste no more time arguing about what a good man should be. Be one."
    let author: String = "Marcus Aurelius"
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("\"\(quote)\"") // Display the quote
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(StoicTheme.primaryTextColor)
                .padding()
                .multilineTextAlignment(.center)
                
            Text("- \(author)") // Display the author of the quote
                .font(.body)
                .foregroundColor(StoicTheme.primaryTextColor)
                .padding(.bottom)
            
            Spacer()
        }
        .background(StoicTheme.secondaryColor) // Use the secondaryColor as the background
        .cornerRadius(10)
        .padding()
        .shadow(radius: 5)
    }
}

// Preview provider to see a preview in Xcode
struct DailyQuoteView_Previews: PreviewProvider {
    static var previews: some View {
        DailyQuoteView()
            .preferredColorScheme(.dark) // To see the look in Dark Mode
            .previewLayout(.sizeThatFits)
    }
}
