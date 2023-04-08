//
//  MenuVM.swift
//  TicTacToe
//
//  Created by Sergio Herrera on 4/6/23.
//

protocol menuDelegate {
    func sendGameResultsToMenuVC() -> GameState
}

class MenuVM {

    var gameState = GameState()
    var isFirstGame: Bool {
        return gameState.scores[0] == 0 && gameState.scores[1] == 0
    }
    
    var titleText = "Tic Tac Toe"
    
    var menuSelection = MenuSelection(mode: 0, skill: 0) {
        didSet {
            // start game based on following:
            // 1. vs Player2 or AI?
            // 2. if vs Player2, find someone looking to play in firebase
            // 3. if Player2 looking to play on firebase, establish connection
            // 4. easy? medium? hard?
            // 5. send initial gamestate to GameVM to start game
        }
    }
    
}
