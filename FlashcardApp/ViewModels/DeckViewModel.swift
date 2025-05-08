// FlashcardApp/FlashcardApp/ViewModels/DeckViewModel.swift

import Foundation
import Combine

class DeckViewModel: ObservableObject {
    @Published var decks: [Deck] = []
    private var dataManager = DataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Subscribe to changes in DataManager
        dataManager.$decks
            .assign(to: \.decks, on: self)
            .store(in: &cancellables)
    }
    
    func addDeck(name: String, description: String) {
        let newDeck = Deck(name: name, description: description)
        dataManager.addDeck(newDeck)
    }
    
    func updateDeck(_ deck: Deck) {
        dataManager.updateDeck(deck)
    }
    
    func deleteDeck(at index: Int) {
        dataManager.deleteDeck(at: index)
    }
    
    func deleteDeck(withId id: UUID) {
        dataManager.deleteDeck(withId: id)
    }
    
    func getDeck(withId id: UUID) -> Deck? {
        return decks.first(where: { $0.id == id })
    }
}