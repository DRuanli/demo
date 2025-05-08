// FlashcardApp/FlashcardApp/Views/Decks/DeckEditView.swift
import SwiftUI

struct DeckEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var deckVM = DeckViewModel()
    
    var deckToEdit: Deck?
    
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var showingAlert = false
    
    var isEditing: Bool {
        deckToEdit != nil
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Deck Information")) {
                    TextField("Deck Name", text: $name)
                    
                    TextField("Description (Optional)", text: $description)
                        .frame(minHeight: 80)
                }
            }
            .navigationTitle(isEditing ? "Edit Deck" : "New Deck")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button(isEditing ? "Save" : "Create") {
                    if name.isEmpty {
                        showingAlert = true
                    } else {
                        saveDeck()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            )
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Incomplete Deck"),
                    message: Text("Deck name is required."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .onAppear {
                if let deck = deckToEdit {
                    name = deck.name
                    description = deck.description
                }
            }
        }
    }
    
    private func saveDeck() {
        if let deck = deckToEdit {
            var updatedDeck = deck
            updatedDeck.name = name
            updatedDeck.description = description
            deckVM.updateDeck(updatedDeck)
        } else {
            deckVM.addDeck(name: name, description: description)
        }
    }
}
