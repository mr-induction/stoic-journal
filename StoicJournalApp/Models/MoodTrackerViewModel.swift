import Foundation
import Combine
import FirebaseFirestore



class MoodTrackerViewModel: ObservableObject {
    @Published var moods: [Mood] = []
    @Published var moodHistory: [Mood] = []
    @Published var selectedMoodId: String? // Track the selected mood ID

    private let db = Firestore.firestore() // Firestore database reference
    
    init() {
        loadMoods()
        loadMoodHistory()
    }
    
    func loadMoods() {
        // Predefined moods, you can replace these with a fetch from Firestore if needed
        moods = [
            Mood(id: UUID().uuidString, icon: "heart.fill", description: "Loved"),
            Mood(id: UUID().uuidString, icon: "cloud.rain.fill", description: "Sad"),
            Mood(id: UUID().uuidString, icon: "bolt.fill", description: "Energetic"),
            // Add more moods as needed
        ]
    }
    
    func loadMoodHistory() {
        // Fetch mood history from Firestore
        db.collection("moodHistory") // Assuming "moodHistory" is the collection name
            .order(by: "timestamp", descending: true)
            .getDocuments { [weak self] (querySnapshot, error) in
                if let error = error {
                    print("Error getting mood history: \(error.localizedDescription)")
                    return
                }

                self?.moodHistory = querySnapshot?.documents.compactMap { document -> Mood? in
                    try? document.data(as: Mood.self)
                } ?? []
            }
    }
    
    func saveMood() {
        guard let selectedMood = moods.first(where: { $0.id == selectedMoodId }) else { return }
        
        let collectionPath = "moodHistory" // The collection path for saving moods
        do {
            let _ = try db.collection(collectionPath).addDocument(from: selectedMood) { error in
                if let error = error {
                    print("Error saving mood: \(error.localizedDescription)")
                } else {
                    DispatchQueue.main.async {
                        self.moodHistory.insert(selectedMood, at: 0) // Insert at the beginning of the history
                    }
                }
            }
        } catch let error {
            print("Error encoding mood for saving: \(error)")
        }
    }
}
