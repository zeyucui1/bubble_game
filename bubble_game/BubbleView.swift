//
//  BubbleView.swift
//  bubble_game
//
//  Created by zeyu cui on 16/4/2024.
//

import SwiftUI

struct BubbleView: View {
    let bubble: Bubble
    let spacing: CGFloat

    var body: some View {
        Circle()
            .fill(bubble.color)
            .frame(width: bubble.size, height: bubble.size)
            .overlay(
                Circle().stroke(Color.white.opacity(0.8), lineWidth: 2)
            )
            .shadow(color: bubble.color.opacity(0.5), radius: 10, x: 0, y: 5)
            .padding(spacing)
            .scaleEffect(animateBubble ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animateBubble)
            .onAppear {
                self.animateBubble.toggle()
            }
    }

    @State private var animateBubble = false
}
