//
//  HighScoreviewModel.swift
//  bubble_game
//
//  Created by zeyu cui on 17/4/2024.
//

import Foundation

class HighScoreViewModel: ObservableObject {
    @Published var scores: [(name: String, score: Int)] = []

    init() {
        loadScores()
    }

    // Computed property to get the highest score
    var highestScore: Int {
            scores.first?.score ?? 0
        }
    // Loads scores from UserDefaults and sorts them in descending order based on score.
    func loadScores() {
        if let scoresData = UserDefaults.standard.array(forKey: "Scores") as? [[String: Any]] {
            scores = scoresData.compactMap {
                guard let name = $0["name"] as? String, let score = $0["score"] as? Int else { return nil }
                return (name, score)
            }.sorted { $0.score > $1.score }
        }
    }

    // Updates or adds a new score, ensuring the high score list remains sorted and only the highest scores are kept.
    func updateScore(newScore: (name: String, score: Int)) {
        if let index = scores.firstIndex(where: { $0.name == newScore.name }) {
            // Update score only if new score is higher
            if newScore.score > scores[index].score {
                scores[index].score = newScore.score
            }
        } else {
            scores.append(newScore)
        }
        scores.sort { $0.score > $1.score }
        saveScores()
    }

    // Removes scores at selected index and saves the updated list to UserDefaults.
    func removeScores(at offsets: IndexSet) {
        scores.remove(atOffsets: offsets)
        saveScores()
    }

    //clear all score record
    func clearScores() {
        UserDefaults.standard.removeObject(forKey: "Scores")
        scores.removeAll()
        saveScores()
    }

    // Saves the current scores to UserDefaults.
    private func saveScores() {
        let scoresData = scores.map { ["name": $0.name, "score": $0.score] }
        UserDefaults.standard.set(scoresData, forKey: "Scores")
    }
}
