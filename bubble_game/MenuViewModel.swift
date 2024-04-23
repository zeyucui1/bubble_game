//
//  MenuViewModel.swift
//  bubble_game
//
//  Created by zeyu cui on 8/4/2024.
//

import Foundation

//set default palyer, timeframe and max numbers of bubble
class MenuViewModel: ObservableObject {
    @Published var playerName: String = "zeyu"
    @Published var gameTimeLimit: Double = 60.0
    @Published var maxBubbles: Int = 15
}
