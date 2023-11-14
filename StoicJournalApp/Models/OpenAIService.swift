import Foundation
import Alamofire
import Combine

class OpenAIService: ObservableObject {
    private var apiKey: String {
        guard let key = ProcessInfo.processInfo.environment["OPENAI_API_KEY"], !key.isEmpty else {
            fatalError("Please set the OPENAI_API_KEY environment variable")
        }
        return key
    }
    
    private let baseURL = URL(string: "https://api.openai.com/v1/chat/completions")!
    
    func generateStoicResponse(from content: String, maxTokens: Int = 2500) -> Future<String, OpenAIService.OpenAIError> {
        return Future { [weak self] promise in
            guard let self = self else { return }
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(self.apiKey)"
            ]
            
            let systemMessageContent = """
 You are Marcus Aurelius, gifted with the wisdom of the ancients. A seeker has presented you with their journal entry, full of modern-day troubles and worries. Your task is to read their words with a Stoic's mind, offering them solace and guidance. You shall respond with three actionable steps they can take to apply Stoic wisdom in their life, addressing their specific concerns with brevity and depth. These steps should help them live in accordance with nature, focus on what is within their control, and maintain tranquility amidst the chaos of life. Remember, your advice is not just philosophy, but a practical roadmap for their daily journey. Ensure your responses are 300 words or less.
 """
            
            let parameters: [String: Any] = [
                "model": "gpt-3.5-turbo-1106",
                "messages": [
                    ["role": "system", "content": systemMessageContent],
                    ["role": "user", "content": content]
                ],
                "max_tokens": maxTokens
            ]
            
            AF.request(self.baseURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: OpenAIResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        if let message = value.choices.first?.message.content.trimmingCharacters(in: .whitespacesAndNewlines), !message.isEmpty {
                            promise(.success(message))
                        } else {
                            promise(.failure(.emptyResponse))
                        }
                    case .failure:
                        promise(.failure(.networkError))
                    }
                }
        }
    }
    
    enum OpenAIError: Error {
        case networkError
        case emptyResponse
    }
    
    struct OpenAIResponse: Decodable {
        struct Choice: Decodable {
            struct Message: Decodable {
                let content: String
            }
            let message: Message
        }
        let choices: [Choice]
    }
}
