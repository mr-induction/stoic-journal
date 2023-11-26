import Foundation

// Define a Tag struct to decode each tag dictionary
struct Tag: Codable {
    var id: String
    var name: String
    var title: String? // Title is now optional
}



struct JournalEntry: Codable, Identifiable {
    var id: UUID? // The local unique identifier
    var documentId: String? // The Firestore document identifier
    var title: String
    var content: String
    var date: Date
    var moodId: String?
    var tags: [Tag] // Now an array of Tag structs
    var stoicResponse: String?


    init(id: UUID? = nil, documentId: String? = nil, title: String, content: String, date: Date, moodId: String? = nil, tags: [Tag], stoicResponse: String? = nil) {
           self.id = id
           self.documentId = documentId
           self.title = title
           self.content = content
           self.date = date
           self.moodId = moodId
           self.tags = tags // Tags is now an array of Tag structs
           self.stoicResponse = stoicResponse
       }

    enum CodingKeys: String, CodingKey {
         case id
         case documentId
         case title
         case content
         case date
         case moodId
         case tags
         case stoicResponse
     }
 }

// Conversion function or logic
func convertJournalTagToTag(journalTag: JournalTag?) -> [Tag] {
    if let journalTag = journalTag {
        // Create a Tag object without a title since it's optional and not present in JournalTag.
        return [Tag(id: journalTag.id, name: journalTag.name, title: nil)]
    } else {
        // If no tag is selected, return an empty array.
        return []
    }
}
