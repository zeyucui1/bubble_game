//
//  HighScoreView.swift
//  bubble_game

//
//  Created by zeyu cui on 16/4/2024.
//

import SwiftUI

struct HighScoreView: View {
    @EnvironmentObject var viewModel: HighScoreViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.scores.indices, id: \.self) { index in
                    HStack {
                        Text("\(index + 1).")
                            .frame(width: 40, alignment: .leading)
                            .font(.system(size: 20))
                        Text("\(viewModel.scores[index].name)")
                            .frame(minWidth: 100, alignment: .leading)
                            .font(.system(size: 20))
                        Spacer()
                        Text("\(viewModel.scores[index].score)")
                            .frame(width: 50, alignment: .trailing)
                            .font(.system(size: 20))
                        Button(action: {
                            viewModel.removeScores(at: IndexSet(integer: index))
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        .frame(width: 30, alignment: .trailing)
                    }
                }
                .onDelete(perform: viewModel.removeScores)
            }

            Spacer()

            Button("Back to Home") {
                presentationMode.wrappedValue.dismiss()
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.cyan)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
        }
        .navigationTitle("Highest Scores")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Clear Scores") {
                    viewModel.clearScores()
                }
            }
        }
    }
}

struct HighScoreView_Previews: PreviewProvider {
    static var previews: some View {
        HighScoreView().environmentObject(HighScoreViewModel())
    }
}
