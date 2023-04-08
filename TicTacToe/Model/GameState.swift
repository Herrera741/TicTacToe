//
//  GameState.swift
//  TicTacToe
//
//  Created by Sergio Herrera on 4/7/23.
//

struct GameState {
    var board: [Move?] = Array(repeating: nil, count: 9)
    var scores = [0, 0]
    var toMove: Player? = nil
    var isGameOver = false
}

var gameState = GameState()
