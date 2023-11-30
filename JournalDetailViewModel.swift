//
//  JournalDetailViewModel.swift
//  StoicJournalApp
//
//  Created by Rin Otori on 11/27/23.
//

import Foundation
import Combine

class JournalDetailViewModel: ObservableObject {
    @Published var isLoading = false
    private var openAIService = OpenAIService()
    private var cancellables = Set<AnyCancellable>()

    func generateStoicCommentary(for content: String, completion: @escaping (String) -> Void) {
        isLoading = true
        openAIService.generateStoicResponse(from: content)
            .sink(receiveCompletion: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.isLoading = false
                }
            }, receiveValue: { response in
                DispatchQueue.main.async {
                    completion(response)
                    self.isLoading = false
                }
            })
            .store(in: &cancellables)
    }
}
