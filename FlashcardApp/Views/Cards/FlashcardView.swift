// FlashcardApp/FlashcardApp/Views/Cards/FlashcardView.swift
import SwiftUI

struct FlashcardView: View {
    let card: Flashcard
    @Binding var isShowingAnswer: Bool
    @State private var offset = CGSize.zero
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(radius: 4)
            
            VStack {
                Text(isShowingAnswer ? "ANSWER" : "QUESTION")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.top)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text(isShowingAnswer ? card.answer : card.question)
                    .font(.title2)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                
                if !isShowingAnswer {
                    Text("Tap to flip")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.bottom)
                }
            }
            .padding()
        }
        .frame(height: 300)
        .rotation3DEffect(
            .degrees(isShowingAnswer ? 180 : 0),
            axis: (x: 0.0, y: 1.0, z: 0.0)
        )
        .scaleEffect(1.0 - abs(offset.width) / 1500)
        .offset(x: offset.width, y: 0)
        .gesture(
            TapGesture()
                .onEnded { _ in
                    withAnimation(.spring()) {
                        isShowingAnswer.toggle()
                    }
                }
        )
    }
}