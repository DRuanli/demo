// FlashcardApp/FlashcardApp/Views/Study/StudyView.swift
import SwiftUI

struct StudyView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var studyVM: StudyViewModel
    
    init(deck: Deck) {
        _studyVM = StateObject(wrappedValue: StudyViewModel(deck: deck))
    }
    
    var body: some View {
        VStack {
            if studyVM.studyCards.isEmpty {
                emptyDeckView
            } else if studyVM.isSessionComplete {
                completionView
            } else {
                studySessionView
            }
        }
        .navigationTitle("Study: \(studyVM.deck.name)")
        .navigationBarBackButtonHidden(studyVM.studyCards.isEmpty ? false : true)
        .navigationBarItems(
            leading: Button("Close") {
                if studyVM.reviewedCount > 0 && !studyVM.isSessionComplete {
                    studyVM.completeSession()
                } else {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        )
    }
    
    var emptyDeckView: some View {
        VStack(spacing: 20) {
            Image(systemName: "tray")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No cards to study")
                .font(.title)
            
            Text("This deck has no cards yet. Add some cards first!")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Return to Deck") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
    
    var studySessionView: some View {
        VStack {
            // Progress indicator
            ProgressView(value: studyVM.progressPercentage)
                .padding(.horizontal)
            
            HStack {
                Text("Card \(studyVM.currentIndex + 1) of \(studyVM.studyCards.count)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if studyVM.reviewedCount > 0 {
                    Text("Correct: \(studyVM.correctCount)/\(studyVM.reviewedCount)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal)
            
            // Card view
            if let card = studyVM.currentCard {
                FlashcardView(card: card, isShowingAnswer: $studyVM.showAnswer)
                    .padding()
                    .onTapGesture {
                        withAnimation {
                            studyVM.flipCard()
                        }
                    }
                
                if studyVM.showAnswer {
                    // Rating buttons
                    HStack(spacing: 15) {
                        RatingButton(
                            text: "Difficult",
                            color: .red,
                            action: { studyVM.rateCard(.difficult) }
                        )
                        
                        RatingButton(
                            text: "Moderate",
                            color: .yellow,
                            action: { studyVM.rateCard(.moderate) }
                        )
                        
                        RatingButton(
                            text: "Easy",
                            color: .green,
                            action: { studyVM.rateCard(.easy) }
                        )
                    }
                    .padding()
                } else {
                    Button("Show Answer") {
                        withAnimation {
                            studyVM.flipCard()
                        }
                    }
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding()
                }
            }
            
            Spacer()
        }
    }
    
    var completionView: some View {
        StudyCompletionView(
            cardsReviewed: studyVM.reviewedCount,
            correctAnswers: studyVM.correctCount,
            onRestart: {
                studyVM.restartSession()
            },
            onFinish: {
                presentationMode.wrappedValue.dismiss()
            }
        )
    }
}

struct RatingButton: View {
    let text: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(color)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}