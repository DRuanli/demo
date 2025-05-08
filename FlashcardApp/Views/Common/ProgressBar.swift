// FlashcardApp/FlashcardApp/Views/Common/ProgressBar.swift

import SwiftUI

struct ProgressBar: View {
    var value: Double
    var color: Color = .blue
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: 8)
                    .opacity(0.2)
                    .foregroundColor(color)
                
                Rectangle()
                    .frame(width: min(CGFloat(value) * geometry.size.width, geometry.size.width), height: 8)
                    .foregroundColor(color)
                    .animation(.linear, value: value)
            }
            .cornerRadius(4)
        }
        .frame(height: 8)
    }
}