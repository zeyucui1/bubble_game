//
//  GameViewModel.swift
//  bubble_game
//
//  Created by zeyu cui on 8/4/2024.
//
import Combine
import SwiftUI

class GameViewModel: ObservableObject {
    @Published var playerName: String
    @Published var maxBubbles: Int
    @Published var gameTimeLeft: Int
    @Published var totalScore: Int = 0
    @Published var bubbles: [Bubble] = []
    @Published var showGameOverAlert: Bool = false

    @Published var screenSize: CGSize = .zero
    @Published var topSafeArea: CGFloat
    @Published var bottomSafeArea: CGFloat
    @Published var topUIHeight: CGFloat

    @Published var showCountdown: Bool = true
    @Published var countdownText: String = "Ready!"
    @Published var countdownValue: Int = 4

    private var gameTimer: AnyCancellable?
    private var bubbleCreationTimer: AnyCancellable?
    private var countdownTimer: AnyCancellable?
    private var updateBubblesTimer: AnyCancellable?

    init(gameTimeLeft: Int, maxBubbles: Int, playerName: String, topSafeArea: CGFloat, bottomSafeArea: CGFloat, topUIHeight: CGFloat) {
        self.gameTimeLeft = gameTimeLeft
        self.maxBubbles = maxBubbles
        self.playerName = playerName
        self.topSafeArea = topSafeArea
        self.bottomSafeArea = bottomSafeArea
        self.topUIHeight = topUIHeight
    }

    // Starts the countdown before the game begins, ensuring the game only starts after the countdown.
    func startCountdown() {
        countdownText = "Ready!"
        countdownValue = 4
        countdownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect().sink { [weak self] _ in
            guard let self = self else { return }
            if self.countdownValue > 0 {
                self.countdownText = self.countdownValue == 4 ? "Ready!" : "\(self.countdownValue)"
                self.countdownValue -= 1
            } else {
                self.showCountdown = false
                self.countdownTimer?.cancel()
                self.startGame()
            }
        }
    }

    // Initializes timers and start game.
    func startGame() {
        setupGame(screenSize: screenSize)
        gameTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect().sink { [weak self] _ in
            self?.updateRemainingTime()
        }
    }

    // Sets up timers for creating and updating bubbles.
    func setupGame(screenSize: CGSize) {
        self.screenSize = screenSize

        bubbleCreationTimer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect().sink { [weak self] _ in
            self?.createBubbles()
        }

        updateBubblesTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect().sink { [weak self] _ in
            self?.updateBubbles()
        }
    }

    private func updateRemainingTime() {
        gameTimeLeft -= 1
        if gameTimeLeft <= 0 {
            endGame()
        }
    }

    // Creates new bubbles on the screen while ensuring they do not overlap with existing bubbles.
    func createBubbles() {
        guard bubbles.count < maxBubbles else { return }
        let newBubblesCount = Int.random(in: 1 ... (maxBubbles - bubbles.count))

        for _ in 0 ..< newBubblesCount {
            var bubble: Bubble?
            var attempt = 0
            repeat {
                bubble = Bubble(screenSize: screenSize, topSafeArea: topSafeArea, topUIHeight: topUIHeight, bottomSafeArea: bottomSafeArea)
                attempt += 1
            } while isOverlap(newBubble: bubble!) && attempt < 10

            if attempt < 10 {
                bubbles.append(bubble!)
            }
        }
    }

    // Randomly shuffles and potentially removes bubbles from the screen, then create new bubbles.
    private func updateBubbles() {
        bubbles = bubbles.shuffled()
        let removeCount = Int.random(in: 0 ... bubbles.count)
        bubbles.removeLast(removeCount)

        createBubbles()
    }

    // Handles the logic when a bubble is tapped, including scoring and removing the bubble.
    func tapBubble(_ bubble: Bubble) {
            if let index = bubbles.firstIndex(where: { $0.id == bubble.id }) {
                let scoreToAdd = bubbles[index].checkLastPoppedColor()
                totalScore += scoreToAdd
                bubbles.remove(at: index)
            }
        }

    // Checks if a newly created bubble overlaps with any existing bubbles.
    private func isOverlap(newBubble: Bubble) -> Bool {
        for existingBubble in bubbles {
            if newBubble.intersects(with: existingBubble) {
                return true
            }
        }
        return false
    }

    // Ends the game by stopping all timers and displaying the alert to check highscore or restart game.
    private func endGame() {
        gameTimer?.cancel()
        bubbleCreationTimer?.cancel()
        updateBubblesTimer?.cancel()
        showGameOverAlert = true
    }

    // Resets the game to its initial state and starts the countdown again.
    func resetGame() {
        totalScore = 0
        gameTimeLeft = 60
        bubbles.removeAll()
        setupGame(screenSize: screenSize)
        showCountdown = true
        startCountdown()
    }
}
