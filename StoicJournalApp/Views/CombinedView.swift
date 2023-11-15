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
                Section(header: Text("Journal Entry").font(StoicTheme.titleFont)) {
                    TextField("Title", text: $title)
                        .padding()
                        .background(StoicTheme.secondaryColor) // Assuming secondaryColor for background
                        .foregroundColor(StoicTheme.primaryTextColor)
                        .font(StoicTheme.primaryFont)
                        .cornerRadius(5)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(StoicTheme.secondaryTextColor, lineWidth: 1))
                        .accessibilityLabel("Journal Title")
                    
                    TextEditor(text: $content)
                        .frame(height: 200)
                        .padding()
                        .background(StoicTheme.secondaryColor) // Assuming secondaryColor for background
                        .foregroundColor(StoicTheme.primaryTextColor)
                        .font(StoicTheme.primaryFont)
                        .cornerRadius(5)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(StoicTheme.secondaryTextColor, lineWidth: 1))
                        .accessibilityLabel("Journal Content")
                    
                    Picker("Select Tag", selection: $selectedTag) {
                        Text("None").tag(nil as JournalTag?) // Handle nil selection
                        ForEach(allAvailableTags, id: \.self) { tag in
                            Text(tag.name).tag(tag as JournalTag?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .foregroundColor(StoicTheme.primaryTextColor)

                    Picker("Select Mood", selection: $selectedMood) {
                        Text("None").tag(nil as Mood?) // Handle nil selection
                        ForEach(allAvailableMoods, id: \.self) { mood in
                            Text(mood.description).tag(mood as Mood?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .foregroundColor(StoicTheme.primaryTextColor)
                    
                    Button("Save") {
                        saveJournalEntry()
                    }
                    .padding()
                    .background(StoicTheme.accentColor) // Use StoicTheme.accentColor for button background
                    .foregroundColor(StoicTheme.secondaryColor) // Use StoicTheme.secondaryColor for button text
                    .cornerRadius(8)
                    .disabled(isLoading)
                    .accessibilityLabel("Save Journal Entry")
                }
                
                Section(header: Text("Stoic Response").font(StoicTheme.titleFont)) {
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
                            .background(StoicTheme.secondaryColor) // Assuming background needed here
                            .foregroundColor(StoicTheme.primaryTextColor)
                    }
                }
                
                Section(header: Text("Saved Journal Entries").font(StoicTheme.titleFont)) {
                    NavigationLink(destination: JournalListView(journalViewModel: journalViewModel)) {
                        Text("View Saved Entries").foregroundColor(StoicTheme.primaryTextColor)
                    }
                }
            }
            .font(StoicTheme.primaryFont) // Makes font consistent throughout the view
            .navigationBarTitle("Combined Journal")
            .onAppear {
                // Set the appearance for NavigationBar when this view appears
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = UIColor(StoicTheme.primaryColor) // Set the background color using StoicTheme
                appearance.titleTextAttributes = [.foregroundColor : UIColor(StoicTheme.accentColor)] // Title color
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(StoicTheme.accentColor)] // Large title color
                
                // Apply the appearance to the navigation bar
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().compactAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
                UINavigationBar.appearance().tintColor = UIColor(StoicTheme.accentColor) // Control color
            }
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
