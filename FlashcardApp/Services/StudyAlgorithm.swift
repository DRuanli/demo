// FlashcardApp/FlashcardApp/Services/StudyAlgorithm.swift
import Foundation

class StudyAlgorithm {
    static func sortCardsForStudy(deck: Deck) -> [Flashcard] {
        // Simple spaced repetition algorithm
        // Priority: 
        // 1. Never reviewed cards
        // 2. Difficult cards reviewed more than 24 hours ago
        // 3. Moderate cards reviewed more than 3 days ago
        // 4. Easy cards reviewed more than 7 days ago
        
        let calendar = Calendar.current
        let now = Date()
        
        return deck.cards.sorted { card1, card2 in
            // Never reviewed cards first
            if card1.confidenceLevel == .notReviewed && card2.confidenceLevel != .notReviewed {
                return true
            }
            if card1.confidenceLevel != .notReviewed && card2.confidenceLevel == .notReviewed {
                return false
            }
            
            // Then sort by review date and confidence level
            guard let lastReviewed1 = card1.lastReviewed, 
                  let lastReviewed2 = card2.lastReviewed else {
                return card1.confidenceLevel.rawValue < card2.confidenceLevel.rawValue
            }
            
            // Calculate days since last review
            let days1 = calendar.dateComponents([.day], from: lastReviewed1, to: now).day ?? 0
            let days2 = calendar.dateComponents([.day], from: lastReviewed2, to: now).day ?? 0
            
            // Calculate due status based on confidence
            func isDue(_ card: Flashcard, daysAgo: Int) -> Bool {
                switch card.confidenceLevel {
                case .difficult: return daysAgo >= 1  // Review difficult cards daily
                case .moderate: return daysAgo >= 3   // Review moderate cards every 3 days
                case .easy: return daysAgo >= 7       // Review easy cards weekly
                case .notReviewed: return true        // Always review new cards
                }
            }
            
            let isDue1 = isDue(card1, daysAgo: days1)
            let isDue2 = isDue(card2, daysAgo: days2)
            
            if isDue1 && !isDue2 {
                return true
            } else if !isDue1 && isDue2 {
                return false
            } else {
                // If both due or both not due, prioritize by confidence level
                return card1.confidenceLevel.rawValue < card2.confidenceLevel.rawValue
            }
        }
    }
}