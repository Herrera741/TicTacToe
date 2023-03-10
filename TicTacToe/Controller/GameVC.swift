//
//  GameVC.swift
//  TicTacToe
//
//  Created by Sergio Herrera on 3/5/23.
//

import UIKit

class GameVC: UIViewController {
    
    @IBOutlet weak var turnImg: UIImageView!
    @IBOutlet var gameBtns: [UIButton]!
    
    var isPlayerOneTurn = true
    var playerOneScore = 0
    var playerTwoScore = 0
    var moves: [Move?] = Array(repeating: nil, count: 9)

    override func viewDidLoad() {
        super.viewDidLoad()
        initBoard()
    }
    
    func initBoard() {
        board.append(gameBoardBtn1)
        board.append(gameBoardBtn2)
        board.append(gameBoardBtn3)
        board.append(gameBoardBtn4)
        board.append(gameBoardBtn5)
        board.append(gameBoardBtn6)
        board.append(gameBoardBtn7)
        board.append(gameBoardBtn8)
        board.append(gameBoardBtn9)
    }
    
    func isFullBoard() -> Bool {
        for button in board {
            if button.title(for: .normal) == nil {
                return false
            }
        }
        
        return true
    }

    @IBAction func gameBoardBtnTapped(_ sender: UIButton) {
        addMoveToBoard(sender)
        
        if isWinningMove(playerOne) {
            playerOneScore += 1
            gameOverAlert(title: "Cross wins!")
        }
        
        if isWinningMove(playerTwo) {
            playerTwoScore += 1
            gameOverAlert(title: "Circle wins!")
        }
        
        if isFullBoard() {
            gameOverAlert(title: "Draw")
        }
    }
    
    func isWinningMove(_ s: String) -> Bool {
        // horizontal wins
        if isPlayerSymbol(gameBoardBtn1, s) && isPlayerSymbol(gameBoardBtn2, s) && isPlayerSymbol(gameBoardBtn3, s) {
            return true
        }
        if isPlayerSymbol(gameBoardBtn4, s) && isPlayerSymbol(gameBoardBtn5, s) && isPlayerSymbol(gameBoardBtn6, s) {
            return true
        }
        if isPlayerSymbol(gameBoardBtn7, s) && isPlayerSymbol(gameBoardBtn8, s) && isPlayerSymbol(gameBoardBtn9, s) {
            return true
        }
        
        // vertical wins
        if isPlayerSymbol(gameBoardBtn1, s) && isPlayerSymbol(gameBoardBtn4, s) && isPlayerSymbol(gameBoardBtn7, s) {
            return true
        }
        if isPlayerSymbol(gameBoardBtn2, s) && isPlayerSymbol(gameBoardBtn5, s) && isPlayerSymbol(gameBoardBtn8, s) {
            return true
        }
        if isPlayerSymbol(gameBoardBtn3, s) && isPlayerSymbol(gameBoardBtn6, s) && isPlayerSymbol(gameBoardBtn9, s) {
            return true
        }
        
        // diagonal wins
        if isPlayerSymbol(gameBoardBtn1, s) && isPlayerSymbol(gameBoardBtn5, s) && isPlayerSymbol(gameBoardBtn9, s) {
            return true
        }
        if isPlayerSymbol(gameBoardBtn3, s) && isPlayerSymbol(gameBoardBtn5, s) && isPlayerSymbol(gameBoardBtn7, s) {
            return true
        }
        
        return false
    }
    
    func isPlayerSymbol(_ button: UIButton, _ symbol: String) -> Bool {
        return button.title(for: .normal) == symbol
    }

    // add player move to board
    func addMoveToBoard(_ sender: UIButton) {
        // "sender" is UIButton aka button in gameboard space
        if sender.title(for: .normal) == nil {
            // valid board space for player move
            if playerTurn == "X" {
                sender.setTitle("X", for: .normal)
                playerTurn = "O"
                turnLabel.text = "O"
            } else {
                sender.setTitle("O", for: .normal)
                self.playerTurn = "X"
                self.turnLabel.text = "X"
            }
            
            sender.isEnabled = false
        }
    }
    
    func gameOverAlert(title: String) {
        let message = "\nCircle \(playerTwoScore) \n\nCross \(playerOneScore)"
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Reset", style: .default, handler: { (_) in
            self.resetBoard()
        }))
        self.present(alertController, animated: true)
    }
    
    func resetBoard() {
        for button in board {
            button.setTitle(nil, for: .normal)
            button.isEnabled = true
        }
        
        playerTurn = "X"
        turnLabel.text = playerTurn
    }
}

enum Player: String {
    case One = "icXmark"
    case Two = "icCircle"
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player.rawValue
    }
}

