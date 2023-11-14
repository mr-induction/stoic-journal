import SwiftUI
import Combine

struct CombinedView: View {
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var selectedTag: JournalTag?
    @State private var selectedMood: Mood?
    @State private var stoicResponse: String = ""
    @State private var isLoading: Bool = false
    @State private var cancellables = Set<AnyCancellable>()
    
    @ObservedObject var journalViewModel = JournalViewModel() // ViewModel for journal entries
    var openAIService = OpenAIService() // Service for getting Stoic responses
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Journal Entry")) {
                    TextField("Title", text: $title)
                        .padding()
                        .border(Color.gray, width: 1)
                        .accessibilityLabel("Journal Title")
                    
                    TextEditor(text: $content)
                        .frame(height: 200)
                        .padding()
                        .border(Color.gray, width: 1)
                        .accessibilityLabel("Journal Content")
                    
                    Picker("Select Tag", selection: $selectedTag) {
                        Text("None").tag(nil as JournalTag?) // Handle nil selection
                        ForEach(allAvailableTags, id: \.id) { tag in
                            Text(tag.name).tag(tag as JournalTag?)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    Picker("Select Mood", selection: $selectedMood) {
                        Text("None").tag(nil as Mood?) // Handle nil selection
                        ForEach(allAvailableMoods, id: \.description) { mood in
                            Text(mood.description).tag(mood as Mood?)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    Button("Save") {
                        isLoading = true
                        saveJournalEntry()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .accessibilityLabel("Save Journal Entry")
                    .disabled(isLoading)
                }
                
                Section(header: Text("Stoic Response")) {
                    Button("Get Stoic Response") {
                        stoicResponse = ""
                        isLoading = true
                        getStoicResponse()
                    }
                    .disabled(isLoading || content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .accessibilityLabel("Get Stoic Response")
                    
                    if isLoading {
                        ProgressView("Loading...")
                    } else {
                        Text(stoicResponse)
                            .padding()
                    }
                }
                
                Section(header: Text("Saved Journal Entries")) {
                    NavigationLink(destination: JournalListView(journalViewModel: journalViewModel)) {
                        Text("View Saved Entries")
                    }
                }
            }
            .font(.body) // Dynamic type support
            .navigationBarTitle("Combined Journal")
        }
    }
    
    private func getStoicResponse() {
        openAIService.generateStoicResponse(from: content)
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
    
    private func saveJournalEntry() {
            isLoading = true
            openAIService.generateStoicResponse(from: content)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    isLoading = false
                    if case .failure(let error) = completion {
                        print("Error: \(error.localizedDescription)")
                    }
                }, receiveValue: { response in
                    let tagArray = selectedTag != nil ? [selectedTag!] : [] // Convert the selectedTag to an array
                    let newEntry = JournalEntry(
                        title: title,
                        content: content,
                        date: Date(),
                        moodId: selectedMood?.description ?? "defaultMoodId",
                        userId: "exampleUserId",
                        tags: tagArray, // Provide the tags array
                        stoicResponse: response
                    )
                    print("Journal Entry before saving: \(newEntry)") // Debug statement

                    FirebaseManager.shared.createJournalEntry(newEntry) { error in
                        if let error = error {
                            print("Error saving journal entry: \(error.localizedDescription)")
                        } else {
                            print("Journal entry saved successfully!")
                        }
                    }
                })
                .store(in: &cancellables)
        }
    }
