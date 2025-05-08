// FlashcardApp/FlashcardApp/Views/Decks/DeckDetailView.swift
import SwiftUI

struct DeckDetailView: View {
    let deck: Deck
    @StateObject private var deckVM = DeckViewModel()
    @StateObject private var flashcardVM = FlashcardViewModel()
    @State private var showingAddCard = false
    @State private var cardToEdit: Flashcard?
    @State private var showingEditDeck = false
    
    var updatedDeck: Deck {
        deckVM.getDeck(withId: deck.id) ?? deck
    }
    
    var body: some View {
        VStack {
            // Deck stats
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(updatedDeck.description)
                        .italic()
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Button(action: {
                        showingEditDeck = true
                    }) {
                        Image(systemName: "pencil")
                            .foregroundColor(.blue)
                    }
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Total: \(updatedDeck.cards.count)")
                        Text("Reviewed: \(updatedDeck.reviewedCardsCount)")
                    }
                    .font(.caption)
                    
                    Spacer()
                    
                    if !updatedDeck.cards.isEmpty {
                        NavigationLink(destination: StudyView(deck: updatedDeck)) {
                            Text("Study")
                                .font(.headline)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            
            // Card list
            List {
                if updatedDeck.cards.isEmpty {
                    Text("No cards in this deck yet. Tap + to add your first card!")
                        .foregroundColor(.gray)
                        .italic()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                } else {
                    ForEach(updatedDeck.cards) { card in
                        CardRow(card: card)
                            .onTapGesture {
                                cardToEdit = card
                                showingAddCard = true
                            }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let card = updatedDeck.cards[index]
                            flashcardVM.deleteCard(withId: card.id, fromDeckWithId: deck.id)
                        }
                    }
                }
            }
        }
        .navigationTitle(updatedDeck.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    cardToEdit = nil
                    showingAddCard = true
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddCard) {
            CardEditView(deckId: deck.id, cardToEdit: cardToEdit)
        }
        .sheet(isPresented: $showingEditDeck) {
            DeckEditView(deckToEdit: updatedDeck)
        }
    }
}

struct CardRow: View {
    let card: Flashcard
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(card.question)
                .font(.headline)
                .lineLimit(1)
            
            Text(card.answer)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(1)
            
            HStack {
                if card.confidenceLevel != .notReviewed {
                    Text(card.confidenceLevel.description)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color(card.confidenceLevel.color))
                        .foregroundColor(.white)
                        .cornerRadius(4)
                }
                
                Spacer()
                
                if let date = card.lastReviewed {
                    Text("Last reviewed: \(date, style: .date)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}