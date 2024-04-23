//
//  HomeView.swift
//  bubble_game
//
//  Created by zeyu cui on 2/4/2024.
//
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var highScoreViewModel: HighScoreViewModel
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()
                Text("BubblePop")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(LinearGradient(colors: [.pink, .blue], startPoint: .leading, endPoint: .trailing))
                Spacer()

                NavigationLink("Game Settings", destination: MenuView())
                    .font(.title2)
                    .padding()
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .foregroundColor(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    .shadow(radius: 5)
                    .padding(.horizontal, 20)

                NavigationLink("High Score", destination: HighScoreView())
                    .font(.title2)
                    .padding()
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .foregroundColor(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    .shadow(radius: 5)
                    .padding(.horizontal, 20)

                Spacer()
            }
            .padding()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(HighScoreViewModel())
    }
}
