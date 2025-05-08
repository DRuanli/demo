// FlashcardApp/FlashcardApp/Views/Decks/DeckListView.swift

import SwiftUI

struct DeckListView: View {
    @StateObject private var deckVM = DeckViewModel()
    @State private var showingAddDeck = false
    @State private var searchText = ""
    
    var filteredDecks: [Deck] {
        if searchText.isEmpty {
            return deckVM.decks
        } else {
            return deckVM.decks.filter { 
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                if filteredDecks.isEmpty {
                    Text("No flashcard decks yet. Tap + to create your first deck!")
                        .foregroundColor(.gray)
                        .italic()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                } else {
                    ForEach(filteredDecks) { deck in
                        NavigationLink(destination: DeckDetailView(deck: deck)) {
                            DeckRow(deck: deck)
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            deckVM.deleteDeck(at: index)
                        }
                    }
                }
            }
            .navigationTitle("Flashcards")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddDeck = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search decks")
            .sheet(isPresented: $showingAddDeck) {
                DeckEditView()
            }
        }
    }
}

struct DeckRow: View {
    let deck: Deck
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(deck.name)
                .font(.headline)
            
            Text("\(deck.cards.count) cards")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            ProgressView(value: deck.completionPercentage)
                .progressViewStyle(LinearProgressViewStyle())
                .frame(height: 5)
                .padding(.top, 4)
        }
        .padding(.vertical, 4)
    }
}
