//
//  Bubble.swift
//  bubble_game
//
//  Created by zeyu cui on 16/4/2024.
//
import SwiftUI

// define pink color beacause the pink color in swiftUI is very similar to red color
extension Color {
    static let lightPink = Color(red: 1.0, green: 0.9, blue: 0.9)
}

// Defines a Bubble entity with properties for game mechanics in a bubble popping game.
struct Bubble: Identifiable {
    let id = UUID()
    var color: Color
    var score: Int
    var position: CGPoint
    var size: CGFloat = 30

    static var lastPoppedColor: Color?
    static var lastPoppedScoreMultiplier: CGFloat = 1.0

    // Initializes a new Bubble with a random position and color/score based on game logic.
    init(screenSize: CGSize, topSafeArea: CGFloat, topUIHeight: CGFloat, bottomSafeArea: CGFloat) {
        let result = Bubble.randomColorAndScore()
        self.color = result.color
        self.score = result.score
        let bubbleRadius = size / 2
        let x = CGFloat.random(in: bubbleRadius...(screenSize.width - bubbleRadius))
        let y = CGFloat.random(in: (topSafeArea + topUIHeight + bubbleRadius)...(screenSize.height - bottomSafeArea - bubbleRadius))
        self.position = CGPoint(x: x, y: y)
    }

    // Provides a random color and corresponding score for a new Bubble instance, with defined probabilities.
    static func randomColorAndScore() -> (color: Color, score: Int) {
        let colors: [Color] = [.red, .lightPink, .green, .blue, .black]
        let scores = [1, 2, 5, 8, 10]
        let probabilities: [Double] = [0.4, 0.3, 0.15, 0.1, 0.05]
        var cumulativeProbability = 0.0
        let randomValue = Double.random(in: 0...1)

        for i in 0 ..< probabilities.count {
            cumulativeProbability += probabilities[i]
            if randomValue <= cumulativeProbability {
                return (colors[i], scores[i])
            }
        }
        return (colors.last!, scores.last!)
    }

    // Updates score multiplier based on the last popped bubble's color and sets the current bubble's color as the last popped.
    mutating func checkLastPoppedColor() -> Int {
        if let lastColor = Bubble.lastPoppedColor, lastColor == color {
            Bubble.lastPoppedScoreMultiplier = 1.5
        } else {
            Bubble.lastPoppedScoreMultiplier = 1.0
        }
        Bubble.lastPoppedColor = color
        return Int(CGFloat(score) * Bubble.lastPoppedScoreMultiplier)
    }

    // Checks if two bubbles intersect based on their positions and sizes.
    func intersects(with other: Bubble) -> Bool {
        let distance = sqrt(pow(position.x - other.position.x, 2) + pow(position.y - other.position.y, 2))
        return distance < (size / 2 + other.size / 2)
    }
}
