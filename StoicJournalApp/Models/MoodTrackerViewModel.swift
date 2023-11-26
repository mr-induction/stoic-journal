import Foundation
import Combine

class MoodTrackerViewModel: ObservableObject {
    @Published var moods: [Mood] = []
    @Published var moodHistory: [Mood] = []
    
    init() {
        loadMoods()
        loadMoodHistory()
    }
    
    func loadMoods() {
        // Load moods from your source
        // Replace this with real data loading logic
        moods = [
            Mood(id: UUID().uuidString, icon: "smiley", description: "Happy"),
            Mood(id: UUID().uuidString, icon: "frown", description: "Sad"),
            Mood(id: UUID().uuidString, icon: "angry", description: "Angry"),
            // Add more moods as needed
        ]
    }
    
    
    func loadMoodHistory() {
        // Load mood history
        // Replace with real data loading logic
        moodHistory = [
            // Add mock mood history data
        ]
    }
    
    func saveMood(mood: Mood) {
        // Assume "moods" is the name of the collection in Firestore where you want to save the mood document
        let collectionPath = "moods"
        
        FirebaseManager.shared.performOperation(.create, collectionPath: collectionPath, document: mood) { result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    // Add the mood to the local history if saved successfully
                    self.moodHistory.append(mood)
                case .failure(let error):
                    // Handle the error, perhaps by showing an alert to the user
                    print("Error saving mood: \(error.localizedDescription)")
                }
            }
        }
    }
}
