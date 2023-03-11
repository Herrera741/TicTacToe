//
//  GameVC.swift
//  TicTacToe
//
//  Created by Sergio Herrera on 3/5/23.
//

import UIKit

class GameVC: UIViewController {
    
    
    @IBOutlet weak var turnLbl: UILabel!
    @IBOutlet weak var turnImgView: UIImageView!
    @IBOutlet weak var vertStackView: UIStackView!
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
        let startingPlayer = isPlayerOneTurn ? Player.One : Player.Two
        
        // set primary background color
        self.view.backgroundColor = UIColor(named: "bgColor")
        // set turn label color
        turnLbl.textColor = UIColor(named: "onBgColor")
        // set turn image view background and border colors
        turnImgView.backgroundColor = UIColor(named: "bgColor")
        turnImgView.image = UIImage(named: startingPlayer.rawValue)?.withTintColor(UIColor(named: "secondaryColor") ?? .lightGray)
        // set vertical stack background color
        vertStackView.backgroundColor = UIColor(named: "overlayRed")
        // set all buttons background color
        for button in gameBtns {
            button.backgroundColor = UIColor(named: "surfaceColor")
        }
    }
    
    @IBAction func gameBtnTapped(_ sender: UIButton) {
        let index = sender.tag - 1
        var player = isPlayerOneTurn ? Player.One : Player.Two

        if notValidMove(in: moves, for: index) { return }
        
        let move = Move(player: player, boardIndex: index)
        moves[index] = move
        sender.setImage(UIImage(named: move.indicator)?.withTintColor(UIColor(named: "secondaryColor") ?? .lightGray, renderingMode: .alwaysOriginal), for: .normal)
        
        if isWinningMove(for: player, in: moves) {
            let playerString = player == .One ? "One" : "Two"
            
            if playerString == "One" {
                playerOneScore += 1
            } else {
                playerTwoScore += 1
            }

            gameOverAlert(title: "Player \(playerString) wins!")
        } else if isDrawGame() {
            gameOverAlert(title: "Draw")
        }
        
        isPlayerOneTurn.toggle()
        player = isPlayerOneTurn ? Player.One : Player.Two
        turnImgView.image = UIImage(named: player.rawValue)?.withTintColor(UIColor(named: "secondaryColor") ?? .lightGray)
    }
    
    func notValidMove(in moves: [Move?], for index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index })
    }
    
    func isWinningMove(for player: Player, in moves: [Move?]) -> Bool {
        let horizPatterns = [[0, 1, 2], [3, 4, 5], [6, 7, 8]]
        let vertPatterns = [[0, 3, 6], [1, 4, 7], [2, 5, 8]]
        let diagPatterns = [[0, 4, 8], [2, 4, 6]]
        let winPatterns = horizPatterns + vertPatterns + diagPatterns
        
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let patternSet = Set(pattern)
            if patternSet.isSubset(of: playerPositions) {
                return true
            }
        }
        
        return false
    }
    
    func isDrawGame() -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
    
    func gameOverAlert(title: String) {
        let message = "\nCircle \(playerTwoScore) \n\nCross \(playerOneScore)"
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Reset", style: .default, handler: { (_) in
            self.resetBoard()
        }))
        present(alertController, animated: true)
    }
    
    func resetBoard() {
        
        // clear moves and replace every index with nils
        moves = Array(repeating: nil, count: 9)
        
        // clear every button from image and set isEnabled to true
        for button in gameBtns {
            button.setImage(nil, for: .normal)
        }
        
        isPlayerOneTurn.toggle()
        initBoard()
    }
}

enum Player: String {
    case One = "icCross"
    case Two = "icCircle"
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player.rawValue
    }
}

