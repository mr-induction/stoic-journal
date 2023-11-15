import Foundation

struct JournalTag: Codable, Hashable {
    var id: String
    var name: String
}

struct Mood: Codable, Hashable {
    var description: String
    var icon: String // URL or asset reference
}

struct JournalEntry: Codable, Identifiable {
    var id: UUID
    var documentId: String? // Add this line for Firestore document ID
    var title: String
    var content: String
    var date: Date
    var moodId: String
    var tags: [JournalTag]
    var stoicResponse: String
    
    // Update the initializer to include the documentId
    init(id: UUID = UUID(), documentId: String? = nil, title: String, content: String, date: Date, moodId: String, tags: [JournalTag], stoicResponse: String) {
        self.id = id
        self.documentId = documentId
        self.title = title
        self.content = content
        self.date = date
        self.moodId = moodId
        self.tags = tags
        self.stoicResponse = stoicResponse
    }
}

