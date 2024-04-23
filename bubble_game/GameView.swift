//
//  GameView.swift
//  bubble_game
//
//  Created by zeyu cui on 2/4/2024.
//

import SwiftUI

struct GameView: View {
    @StateObject var viewModel: GameViewModel
    @EnvironmentObject var highScoreViewModel: HighScoreViewModel
    @State private var navigateToHighScores = false

    var gameTimeLimit: Int
    var maxBubbles: Int
    var playerName: String

    let topAreaHeight: CGFloat = 100
    let bubbleSpacing: CGFloat = 10

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Color.white.edgesIgnoringSafeArea(.all)

                    if viewModel.showCountdown {
                        Text(viewModel.countdownText)
                            .font(.system(size: 90, weight: .bold))
                            .foregroundStyle(LinearGradient(colors: [.pink, .blue], startPoint: .leading, endPoint: .trailing))
                            .transition(.opacity)
                            .animation(.easeOut, value: viewModel.countdownText)
                    } else {
                        VStack {
                            HStack {
                                Text("Player: \(viewModel.playerName)")
                                    .font(.headline)

                                Spacer()

                                Text("Time Left: \(viewModel.gameTimeLeft)")
                                    .font(.headline)
                                    .foregroundColor(.red)

                                Spacer()

                                Text("Score: \(viewModel.totalScore) (Highest: \(highScoreViewModel.highestScore))")
                                    .font(.headline).foregroundColor(.green)
                            }
                            .padding(.horizontal)
                            .padding(.top, geometry.safeAreaInsets.top)
                            .background(Color.white)

                            Spacer()

                            GeometryReader { _ in
                                ForEach(viewModel.bubbles) { bubble in
                                    BubbleView(bubble: bubble, spacing: bubbleSpacing)
                                        .position(x: bubble.position.x, y: bubble.position.y)
                                        .onTapGesture {
                                            viewModel.tapBubble(bubble)
                                        }
                                }
                            }
                            Spacer()
                        }
                    }
                }
                .onAppear {
                    viewModel.gameTimeLeft = gameTimeLimit
                    viewModel.maxBubbles = maxBubbles
                    viewModel.playerName = playerName

                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        let adjustedSize = CGSize(
                            width: geometry.size.width,
                            height: geometry.size.height - topAreaHeight - geometry.safeAreaInsets.bottom
                        )
                        viewModel.setupGame(screenSize: adjustedSize)
                        viewModel.startCountdown()
                    }
                }
                .alert(isPresented: $viewModel.showGameOverAlert) {
                    Alert(
                        title: Text("Game Over"),
                        message: Text("Your score is \(viewModel.totalScore)"),
                        primaryButton: .default(Text("Restart")) {
                            viewModel.resetGame()
                        },
                        secondaryButton: .cancel(Text("Check Score")) {
                            highScoreViewModel.updateScore(newScore: (name: viewModel.playerName, score: viewModel.totalScore))
                            navigateToHighScores = true
                        }
                    )
                }
            }
            .padding()
            .navigationTitle("Gaming")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $navigateToHighScores) {
                HighScoreView()
            }
        }
    }
}
