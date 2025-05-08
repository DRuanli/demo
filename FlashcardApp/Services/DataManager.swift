// FlashcardApp/FlashcardApp/Services/DataManager.swift
import Foundation
import Combine

class DataManager {
    static let shared = DataManager()
    
    private let decksKey = "flashcards_decks"
    private let sessionsKey = "study_sessions"
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    // Published properties for reactive updates
    @Published var decks: [Deck] = []
    @Published var sessions: [StudySession] = []
    
    private init() {
        loadDecks()
        loadSessions()
    }
    
    // MARK: - Deck Operations
    
    func loadDecks() {
        if let data = UserDefaults.standard.data(forKey: decksKey),
           let decodedDecks = try? decoder.decode([Deck].self, from: data) {
            decks = decodedDecks
        }
    }
    
    func saveDecks() {
        if let encodedData = try? encoder.encode(decks) {
            UserDefaults.standard.set(encodedData, forKey: decksKey)
        }
    }
    
    func addDeck(_ deck: Deck) {
        decks.append(deck)
        saveDecks()
    }
    
    func updateDeck(_ deck: Deck) {
        if let index = decks.firstIndex(where: { $0.id == deck.id }) {
            decks[index] = deck
            saveDecks()
        }
    }
    
    func deleteDeck(at index: Int) {
        decks.remove(at: index)
        saveDecks()
    }
    
    func deleteDeck(withId id: UUID) {
        decks.removeAll { $0.id == id }
        saveDecks()
    }
    
    // MARK: - Card Operations
    
    func addCard(_ card: Flashcard, toDeckWithId deckId: UUID) {
        if let index = decks.firstIndex(where: { $0.id == deckId }) {
            decks[index].cards.append(card)
            saveDecks()
        }
    }
    
    func updateCard(_ card: Flashcard, inDeckWithId deckId: UUID) {
        if let deckIndex = decks.firstIndex(where: { $0.id == deckId }),
           let cardIndex = decks[deckIndex].cards.firstIndex(where: { $0.id == card.id }) {
            decks[deckIndex].cards[cardIndex] = card
            saveDecks()
        }
    }
    
    func deleteCard(withId cardId: UUID, fromDeckWithId deckId: UUID) {
        if let deckIndex = decks.firstIndex(where: { $0.id == deckId }) {
            decks[deckIndex].cards.removeAll { $0.id == cardId }
            saveDecks()
        }
    }
    
    // MARK: - Study Session Operations
    
    func loadSessions() {
        if let data = UserDefaults.standard.data(forKey: sessionsKey),
           let decodedSessions = try? decoder.decode([StudySession].self, from: data) {
            sessions = decodedSessions
        }
    }
    
    func saveSessions() {
        if let encodedData = try? encoder.encode(sessions) {
            UserDefaults.standard.set(encodedData, forKey: sessionsKey)
        }
    }
    
    func addSession(_ session: StudySession) {
        sessions.append(session)
        saveSessions()
    }
    
    func clearAllData() {
        decks = []
        sessions = []
        saveDecks()
        saveSessions()
    }
}