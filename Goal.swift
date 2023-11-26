import Foundation

struct Goal: Identifiable, Codable {
    var id: UUID = UUID()
    var firestoreDocumentId: String?
    var title: String
    var description: String
    var milestones: [Milestone]?
    
    var progress: Double {
        // Calculate progress based on completed milestones
        guard let milestones = milestones, !milestones.isEmpty else { return 0 }
        let completed = milestones.filter { $0.isCompleted }.count
        return Double(completed) / Double(milestones.count)
    }
    
    var dictionary: [String: Any] {
        var dict: [String: Any] = [
            "id": id.uuidString,
            "firestoreDocumentId": firestoreDocumentId ?? "",
            "title": title,
            "description": description,
            "progress": progress
        ]
        if let milestoneDicts = milestones?.map({ $0.dictionary }) {
            dict["milestones"] = milestoneDicts
        }
        return dict
    }
    
    // Nested Milestone struct
    struct Milestone: Codable, Identifiable {
        var id = UUID()
        var description: String
        var isCompleted: Bool
        
        var dictionary: [String: Any] {
            return [
                "id": id.uuidString,
                "description": description,
                "isCompleted": isCompleted
            ]
        }
    }
}

