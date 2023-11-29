import Foundation

// The Goal struct represents a goal with an array of Milestone objects.
struct Goal: Identifiable, Codable {
    // Unique identifier for the Goal, defaulting to a new UUID.
    var id: UUID = UUID()
    // Optional string to store a Firestore document ID.
    var firestoreDocumentId: String?
    // Title of the Goal.
    var title: String
    // Description of the Goal.
    var description: String
    // Optional array of Milestone objects.
    var milestones: [Milestone]?
    
    // Computed property to calculate the progress of the Goal.
    var progress: Double {
        // Ensure there are milestones and the array is not empty.
        guard let milestones = milestones, !milestones.isEmpty else { return 0 }
        // Count the number of completed milestones.
        let completed = milestones.filter { $0.isCompleted }.count
        // Calculate the progress as a percentage.
        return Double(completed) / Double(milestones.count)
    }
    
    // Computed property to represent the Goal as a dictionary for Firestore.
    var dictionary: [String: Any] {
        // Start with the basic properties of the Goal.
        var dict: [String: Any] = [
            "id": id.uuidString,
            "firestoreDocumentId": firestoreDocumentId ?? "",
            "title": title,
            "description": description,
            "progress": progress
        ]
        // If milestones exist, convert them to dictionaries and add to the dict.
        if let milestoneDicts = milestones?.map({ $0.dictionary }) {
            dict["milestones"] = milestoneDicts
        }
        // Return the complete dictionary.
        return dict
    }
    
    // Nested Milestone struct representing a step in achieving the Goal.
    struct Milestone: Codable, Identifiable {
        // Unique identifier for the Milestone, defaulting to a new UUID.
        var id = UUID()
        // Description of the Milestone.
        var description: String
        // Boolean indicating if the Milestone is completed.
        var isCompleted: Bool
        
        // Computed property to represent the Milestone as a dictionary for Firestore.
        var dictionary: [String: Any] {
            // Return a dictionary with the Milestone's properties.
            return [
                "id": id.uuidString,
                "description": description,
                "isCompleted": isCompleted
            ]
        }
    }
}
