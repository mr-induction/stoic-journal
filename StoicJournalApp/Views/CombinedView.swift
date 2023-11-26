
<<<<<<< HEAD
// Assuming allAvailableTags, allAvailableMoods, and journalPrompts are defined elsewhere

struct CombinedView: View {
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var selectedTag: JournalTag?
    @State private var selectedMood: Mood?
    @State private var stoicResponse: String = ""
    @State private var isLoading: Bool = false
    @State private var cancellables = Set<AnyCancellable>()
    @State private var showingSaveConfirmation = false // For save confirmation alert
    
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
                    
                    Button("Add Random Prompt") {
                        addRandomPrompt()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    Picker("Select Tag", selection: $selectedTag) {
                        Text("None").tag(nil as JournalTag?)
                        ForEach(allAvailableTags, id: \.id) { tag in
                            Text(tag.name).tag(tag as JournalTag?)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    Picker("Select Mood", selection: $selectedMood) {
                        Text("None").tag(nil as Mood?)
                        ForEach(allAvailableMoods, id: \.description) { mood in
                            Text(mood.description).tag(mood as Mood?)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    Button("Save") {
                        saveJournalEntry()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disabled(isLoading)
                    .accessibilityLabel("Save Journal Entry")
                    .alert(isPresented: $showingSaveConfirmation) {
                        Alert(
                            title: Text("Confirmation"),
                            message: Text("Journal entry saved successfully."),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
                
                Section(header: Text("Stoic Response")) {
                    Button("Get Stoic Response") {
                        stoicResponse = ""
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
            .navigationBarTitle("Combined Journal")
        }
    }
    
    private func addRandomPrompt() {
        let randomPrompt = journalPrompts.randomElement() ?? "Default Prompt"
        print("Selected prompt: \(randomPrompt)") // Debug statement
        content += (content.isEmpty ? "" : "\n\n") + randomPrompt
    }
    
    private func getStoicResponse() {
        isLoading = true
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
        let tagArray = selectedTag != nil ? [selectedTag!] : []
        let newEntry = JournalEntry(
            title: title,
            content: content,
            date: Date(),
            moodId: selectedMood?.description ?? "defaultMoodId",
            tags: tagArray,
            stoicResponse: stoicResponse
        )
        
        FirebaseManager.shared.createJournalEntry(newEntry) { error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    // Handle the error by showing an alert or some other user feedback
                    print("Error saving journal entry: \(error.localizedDescription)")
                } else {
                    self.showingSaveConfirmation = true // Show confirmation alert on successful save
                }
            }
        }
        
        // Preview provider omitted for brevity
    }
}
=======
>>>>>>> 7787fa4 (Initial commit)
