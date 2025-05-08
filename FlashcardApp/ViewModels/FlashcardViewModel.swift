//FlashcardApp/FlashcardApp/ViewModels/FlashcardViewModel.swift
import Foundation
import Combine

class FlashcardViewModel: ObservableObject {
    private var dataManager = DataManager.shared
    
    func addCard(question: String, answer: String, toDeckWithId deckId: UUID) {
        let newCard = Flashcard(question: question, answer: answer)
        dataManager.addCard(newCard, toDeckWithId: deckId)
    }
    
    func updateCard(_ card: Flashcard, inDeckWithId deckId: UUID) {
        dataManager.updateCard(card, inDeckWithId: deckId)
    }
    
    func deleteCard(withId cardId: UUID, fromDeckWithId deckId: UUID) {
        dataManager.deleteCard(withId: cardId, fromDeckWithId: deckId)
    }
    
    func updateConfidenceLevel(cardId: UUID, deckId: UUID, level: Flashcard.ConfidenceLevel) {
        if let deck = dataManager.decks.first(where: { $0.id == deckId }),
           let cardIndex = deck.cards.firstIndex(where: { $0.id == cardId }) {
            var updatedCard = deck.cards[cardIndex]
            updatedCard.confidenceLevel = level
            updatedCard.lastReviewed = Date()
            dataManager.updateCard(updatedCard, inDeckWithId: deckId)
        }
    }
}
