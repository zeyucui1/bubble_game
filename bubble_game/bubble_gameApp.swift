//
//  bubble_gameApp.swift
//  bubble_game
//
//  Created by zeyu cui on 2/4/2024.
//

import SwiftUI

@main
struct BubbleGameApp: App {
    @StateObject var highScoreViewModel = HighScoreViewModel()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(highScoreViewModel)
        }
    }
}
