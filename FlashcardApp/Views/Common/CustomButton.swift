// FlashcardApp/FlashcardApp/Views/Common/CustomButton.swift
import SwiftUI

struct CustomButton: View {
    let text: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(text)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
}