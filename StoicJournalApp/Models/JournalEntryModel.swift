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
    var id: UUID // Changed from 'let' to 'var'
    var title: String
    var content: String
    var date: Date
    var moodId: String
    var tags: [JournalTag]
    var stoicResponse: String // Add Stoic response property
    
    init(title: String, content: String, date: Date, moodId: String, userId: String, tags: [JournalTag], stoicResponse: String) {
        self.id = UUID() // Generate a new UUID for each instance
        self.title = title
        self.content = content
        self.date = date
        self.moodId = moodId
        self.tags = tags
        self.stoicResponse = stoicResponse // Initialize Stoic response
    }
}

