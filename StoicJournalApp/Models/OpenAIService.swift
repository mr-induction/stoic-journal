import Foundation
import Alamofire
import Combine

class OpenAIService: ObservableObject {
    private let apiKey: String
    private let baseURL = URL(string: "https://api.openai.com/v1/chat/completions")!

    init() {
        guard let key = ProcessInfo.processInfo.environment["OPENAI_API_KEY"], !key.isEmpty else {
            fatalError("Please set the OPENAI_API_KEY environment variable")
        }
        self.apiKey = key
    }

    func generateStoicResponse(from content: String, maxTokens: Int = 2500) -> Future<String, OpenAIError> {
        let systemMessageContent = """
        You are Marcus Aurelius, gifted with the wisdom of the ancients. As a Stoic philosopher and emperor, you understand the importance of virtue, reason, and self-control. Reflect on the journal entry provided and offer guidance that aligns with Stoic principles. Provide insights that encourage resilience, clarity, and actionable steps to address any challenges mentioned, fostering a mindset of growth and equanimity. Your words should inspire the journal writer to view their circumstances through the lens of Stoicism, turning obstacles into opportunities for personal development.
        """
        return performRequest(with: systemMessageContent, userContent: content, maxTokens: maxTokens)
    }

    func decomposeGoal(from goal: String, maxTokens: Int = 250) -> Future<[String], OpenAIError> {
        let systemMessageContent = """
        Given the goal: '\(goal)', decompose it into manageable, concrete milestones...
        """
        return performRequest(with: systemMessageContent, userContent: goal, maxTokens: maxTokens)
            .tryMap { response -> [String] in
                response.split(separator: "\n").map(String.init)
            }
            .mapError { error -> OpenAIError in
                (error as? OpenAIError) ?? .unknown
            }
            .asFuture()
    }

    private func performRequest(with systemMessageContent: String, userContent: String, maxTokens: Int) -> Future<String, OpenAIError> {
        return Future { [weak self] promise in
            guard let self = self else { return }

            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(self.apiKey)"
            ]

            let parameters: [String: Any] = [
                "model": "gpt-3.5-turbo-1106",
                "messages": [
                    ["role": "system", "content": systemMessageContent],
                    ["role": "user", "content": userContent]
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
}

extension Publisher {
    func asFuture() -> Future<Output, Failure> {
        return Future { promise in
            var cancellable: AnyCancellable? = nil
            cancellable = self.sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    promise(.failure(error))
                }
                cancellable?.cancel()
            }, receiveValue: { value in
                promise(.success(value))
            })
        }
    }
}

// Error and response structures remain the same.
enum OpenAIError: Error {
    case networkError
    case emptyResponse
    case unknown // Added the 'unknown' case to handle unexpected errors
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
