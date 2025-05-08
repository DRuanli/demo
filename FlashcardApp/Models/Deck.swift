// FlashcardApp/FlashcardApp/Models/Deck.swift
import Foundation

struct Deck: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var description: String
    var cards: [Flashcard]
    var lastStudied: Date?
    var createdAt: Date = Date()
    
    init(name: String, description: String, cards: [Flashcard] = []) {
        self.name = name
        self.description = description
        self.cards = cards
    }
    
    static func == (lhs: Deck, rhs: Deck) -> Bool {
        return lhs.id == rhs.id
    }
    
    var completionPercentage: Double {
        guard !cards.isEmpty else { return 0 }
        let reviewedCards = cards.filter { $0.confidenceLevel != .notReviewed }
        return Double(reviewedCards.count) / Double(cards.count)
    }
    
    var reviewedCardsCount: Int {
        return cards.filter { $0.confidenceLevel != .notReviewed }.count
    }
}