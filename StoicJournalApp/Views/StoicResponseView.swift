import SwiftUI
import Combine

struct StoicResponseView: View {
    @State private var userContent: String = ""
    @State private var stoicResponse: String = ""
    @State private var isLoading: Bool = false
    @State private var cancellables = Set<AnyCancellable>()

    var openAIService: OpenAIService

    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                if userContent.isEmpty {
                    Text("Enter your thoughts or questions here.")
                        .foregroundColor(.gray)
                        .padding(8)
                }
                TextEditor(text: $userContent)
                    .opacity(userContent.isEmpty ? 0.25 : 1)
            }
            .border(Color.gray, width: 1)
            .padding()
            .onTapGesture {
                hideKeyboard()
            }

            Button("Get Stoic Response") {
                fetchStoicResponse()
            }
            .disabled(isLoading || userContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

            if isLoading {
                ProgressView("Loading...")
            } else {
                ScrollView {
                    Text(stoicResponse)
                        .padding()
                }
            }
        }
    }

    private func fetchStoicResponse() {
        stoicResponse = ""
        isLoading = true

        openAIService.generateStoicResponse(from: userContent)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                isLoading = false
                if case .failure(let error) = completion {
                    stoicResponse = "Error: \(error.localizedDescription)"
                }
            }, receiveValue: { response in
                stoicResponse = response
            })
            .store(in: &cancellables)
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct StoicResponseView_Previews: PreviewProvider {
    static var previews: some View {
        StoicResponseView(openAIService: OpenAIService())
    }
}
