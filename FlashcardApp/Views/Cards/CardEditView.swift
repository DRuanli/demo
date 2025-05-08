// FlashcardApp/FlashcardApp/Views/Cards/CardEditView.swift
import SwiftUI

struct CardEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var flashcardVM = FlashcardViewModel()
    
    let deckId: UUID
    var cardToEdit: Flashcard?
    
    @State private var question: String = ""
    @State private var answer: String = ""
    @State private var showingAlert = false
    
    var isEditing: Bool {
        cardToEdit != nil
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Question")) {
                    TextEditor(text: $question)
                        .frame(minHeight: 100)
                }
                
                Section(header: Text("Answer")) {
                    TextEditor(text: $answer)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle(isEditing ? "Edit Card" : "New Card")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button(isEditing ? "Save" : "Create") {
                    if question.isEmpty || answer.isEmpty {
                        showingAlert = true
                    } else {
                        saveCard()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            )
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Incomplete Card"),
                    message: Text("Both question and answer are required."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .onAppear {
                if let card = cardToEdit {
                    question = card.question
                    answer = card.answer
                }
            }
        }
    }
    
    private func saveCard() {
        if let card = cardToEdit {
            var updatedCard = card
            updatedCard.question = question
            updatedCard.answer = answer
            flashcardVM.updateCard(updatedCard, inDeckWithId: deckId)
        } else {
            flashcardVM.addCard(question: question, answer: answer, toDeckWithId: deckId)
        }
    }
}