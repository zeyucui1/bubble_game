//
//  MenuView.swift
//  bubble_game
//
//  Created by zeyu cui on 2/4/2024.
//

import SwiftUI

struct MenuView: View {
    @StateObject var viewModel = MenuViewModel()
    @EnvironmentObject var highScoreViewModel: HighScoreViewModel
    var body: some View {
        VStack(spacing: 20) {
            Text("Bubble pop player")
                .font(.title2)
                .bold()
                .foregroundStyle(LinearGradient(colors: [.pink, .blue], startPoint: .leading, endPoint: .trailing))

            TextField("Please enter your name here:", text: $viewModel.playerName)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .foregroundColor(.black)
                .padding(.horizontal)

            VStack {
                Text("Game time limit: \(Int(viewModel.gameTimeLimit)) seconds")
                    .font(.headline)
                    .foregroundStyle(LinearGradient(colors: [.pink, .blue], startPoint: .leading, endPoint: .trailing))

                Slider(value: $viewModel.gameTimeLimit, in: 15...60, step: 1)
                    .accentColor(.cyan)
            }
            .padding(.horizontal)

            VStack {
                Text("Maximum bubbles: \(viewModel.maxBubbles)")
                    .font(.headline)
                    .foregroundStyle(LinearGradient(colors: [.pink, .blue], startPoint: .leading, endPoint: .trailing))

                Slider(value: Binding(get: {
                    Double(self.viewModel.maxBubbles)
                }, set: {
                    self.viewModel.maxBubbles = Int($0)
                }), in: 1...15, step: 1)
                    .accentColor(.cyan)
            }
            .padding(.horizontal)

            NavigationLink {
                GameView(
                    viewModel: GameViewModel(
                        gameTimeLeft: Int(viewModel.gameTimeLimit),
                        maxBubbles: viewModel.maxBubbles,
                        playerName: viewModel.playerName,
                        topSafeArea: 50,
                        bottomSafeArea: 50,
                        topUIHeight: 50
                    ),
                    gameTimeLimit: Int(viewModel.gameTimeLimit),
                    maxBubbles: viewModel.maxBubbles,
                    playerName: viewModel.playerName
                )
            } label: {
                Text("Play Game")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.cyan)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    .padding(.horizontal)
            }
        }
        .padding()
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView().environmentObject(HighScoreViewModel())
    }
}
