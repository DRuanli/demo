// FlashcardApp/FlashcardApp/Models/StudySession.swift

import Foundation

struct StudySession: Identifiable, Codable {
    var id: UUID = UUID()
    var deckId: UUID
    var startTime: Date = Date()
    var endTime: Date?
    var cardsReviewed: Int = 0
    var correctAnswers: Int = 0
    
    var duration: TimeInterval? {
        guard let endTime = endTime else { return nil }
        return endTime.timeIntervalSince(startTime)
    }
    
    var accuracy: Double {
        guard cardsReviewed > 0 else { return 0 }
        return Double(correctAnswers) / Double(cardsReviewed)
    }
    
    mutating func endSession(cardsReviewed: Int, correctAnswers: Int) {
        self.endTime = Date()
        self.cardsReviewed = cardsReviewed
        self.correctAnswers = correctAnswers
    }
}