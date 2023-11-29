//
//  JournalDetailViewModel.swift
//  StoicJournalApp
//
//  Created by Rin Otori on 11/27/23.
//

import Foundation
import Combine

class JournalDetailViewModel: ObservableObject {
    @Published var stoicResponse: String? = nil
    @Published var isLoading = false
    private var openAIService = OpenAIService()
    private var cancellables = Set<AnyCancellable>()

    func generateStoicCommentary(for content: String) {
        isLoading = true
        openAIService.generateStoicResponse(from: content)
            .sink(receiveCompletion: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.isLoading = false
                }
            }, receiveValue: { [weak self] response in
                DispatchQueue.main.async {
                    self?.stoicResponse = response
                    self?.isLoading = false
                }
            })
            .store(in: &cancellables)
    }
}
