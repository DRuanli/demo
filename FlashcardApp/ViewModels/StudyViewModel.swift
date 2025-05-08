// FlashcardApp/FlashcardApp/ViewModels/StudyViewModel.swift
import Foundation
import Combine

class StudyViewModel: ObservableObject {
    @Published var currentIndex = 0
    @Published var showAnswer = false
    @Published var isSessionComplete = false
    @Published var studyCards: [Flashcard] = []
    
    var deck: Deck
    private var dataManager = DataManager.shared
    private var session: StudySession
    
    @Published var correctCount = 0
    @Published var reviewedCount = 0
    
    init(deck: Deck) {
        self.deck = deck
        self.session = StudySession(deckId: deck.id)
        self.studyCards = StudyAlgorithm.sortCardsForStudy(deck: deck)
    }
    
    var currentCard: Flashcard? {
        guard currentIndex < studyCards.count else { return nil }
        return studyCards[currentIndex]
    }
    
    var progressPercentage: Double {
        guard !studyCards.isEmpty else { return 0 }
        return Double(currentIndex) / Double(studyCards.count)
    }
    
    func flipCard() {
        showAnswer.toggle()
    }
    
    func rateCard(_ confidenceLevel: Flashcard.ConfidenceLevel) {
        guard let card = currentCard else { return }
        
        // Track statistics
        reviewedCount += 1
        if confidenceLevel == .moderate || confidenceLevel == .easy {
            correctCount += 1
        }
        
        // Update card confidence
        if let cardVM = FlashcardViewModel() {
            cardVM.updateConfidenceLevel(
                cardId: card.id,
                deckId: deck.id,
                level: confidenceLevel
            )
        }
        
        // Move to next card
        showAnswer = false
        currentIndex += 1
        
        // Check if session is complete
        if currentIndex >= studyCards.count {
            completeSession()
        }
    }
    
    func nextCard() {
        if !showAnswer {
            showAnswer = true
        } else {
            showAnswer = false
            currentIndex += 1
            
            // Check if session is complete
            if currentIndex >= studyCards.count {
                completeSession()
            }
        }
    }
    
    func completeSession() {
        isSessionComplete = true
        
        // Update session data
        session.endSession(cardsReviewed: reviewedCount, correctAnswers: correctCount)
        
        // Save session
        dataManager.addSession(session)
        
        // Update deck's last studied date
        if var updatedDeck = dataManager.decks.first(where: { $0.id == deck.id }) {
            updatedDeck.lastStudied = Date()
            dataManager.updateDeck(updatedDeck)
        }
    }
    
    func restartSession() {
        currentIndex = 0
        showAnswer = false
        isSessionComplete = false
        correctCount = 0
        reviewedCount = 0
        session = StudySession(deckId: deck.id)
        studyCards = StudyAlgorithm.sortCardsForStudy(deck: deck)
    }
}