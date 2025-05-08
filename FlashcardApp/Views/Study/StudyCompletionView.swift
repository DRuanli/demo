// FlashcardApp/FlashcardApp/Views/Study/StudyCompletionView.swift
import SwiftUI

struct StudyCompletionView: View {
    let cardsReviewed: Int
    let correctAnswers: Int
    let onRestart: () -> Void
    let onFinish: () -> Void
    
    var accuracy: Double {
        guard cardsReviewed > 0 else { return 0 }
        return Double(correctAnswers) / Double(cardsReviewed)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
            
            Text("Study Session Complete!")
                .font(.title)
                .fontWeight(.bold)
            
            VStack(spacing: 10) {
                HStack {
                    Text("Cards reviewed:")
                    Spacer()
                    Text("\(cardsReviewed)")
                        .fontWeight(.bold)
                }
                
                HStack {
                    Text("Correct answers:")
                    Spacer()
                    Text("\(correctAnswers)")
                        .fontWeight(.bold)
                }
                
                HStack {
                    Text("Accuracy:")
                    Spacer()
                    Text(String(format: "%.1f%%", accuracy * 100))
                        .fontWeight(.bold)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            Text(motivationalMessage)
                .multilineTextAlignment(.center)
                .italic()
                .foregroundColor(.secondary)
                .padding()
            
            HStack(spacing: 20) {
                Button(action: onRestart) {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Restart")
                    }
                    .frame(minWidth: 120)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                
                Button(action: onFinish) {
                    HStack {
                        Image(systemName: "checkmark")
                        Text("Finish")
                    }
                    .frame(minWidth: 120)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
        }
        .padding()
    }
    
    var motivationalMessage: String {
        if accuracy >= 0.9 {
            return "Excellent work! Your hard work is paying off."
        } else if accuracy >= 0.7 {
            return "Good job! Keep practicing to improve even more."
        } else {
            return "Practice makes perfect. Keep going!"
        }
    }
}
