// FlashcardApp/FlashcardApp/Models/Flashcard.swift
import Foundation

struct Flashcard: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var question: String
    var answer: String
    var lastReviewed: Date?
    var confidenceLevel: ConfidenceLevel
    
    enum ConfidenceLevel: Int, Codable, CaseIterable {
        case notReviewed = 0
        case difficult = 1
        case moderate = 2
        case easy = 3
        
        var description: String {
            switch self {
            case .notReviewed: return "Not Reviewed"
            case .difficult: return "Difficult"
            case .moderate: return "Moderate"
            case .easy: return "Easy"
            }
        }
        
        var color: String {
            switch self {
            case .notReviewed: return "Gray"
            case .difficult: return "Red"
            case .moderate: return "Yellow"
            case .easy: return "Green"
            }
        }
    }
    
    init(question: String, answer: String) {
        self.question = question
        self.answer = answer
        self.confidenceLevel = .notReviewed
    }
    
    static func == (lhs: Flashcard, rhs: Flashcard) -> Bool {
        return lhs.id == rhs.id
    }
}