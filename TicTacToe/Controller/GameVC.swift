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
    
    var humanScore = 0
    var computerScore = 0
    var moves: [Move?] = Array(repeating: nil, count: 9)

    override func viewDidLoad() {
        super.viewDidLoad()
        initBoard()
    }
    
    func initBoard() {
        // set primary background color
        self.view.backgroundColor = UIColor(named: "bgColor")
        // set turn label color
        turnLbl.textColor = UIColor(named: "onBgColor")
        // set turn image view background and border colors
        turnImgView.backgroundColor = UIColor(named: "bgColor")
        turnImgView.image = UIImage(named: Player.Human.rawValue)?.withTintColor(UIColor(named: "secondaryColor") ?? .lightGray)
        // set vertical stack background color
        vertStackView.backgroundColor = UIColor(named: "overlayRed")
        // set all buttons background color
        for button in gameBtns {
            button.backgroundColor = UIColor(named: "surfaceColor")
        }
    }
    
    @IBAction func gameBtnTapped(_ sender: UIButton) {
        // human makes their move...
        let index = sender.tag - 1
        if notValidMove(in: moves, for: index) { return }
        moves[index] = Move(player: .Human, boardIndex: index)

        var playerImage = getPlayerImage(for: moves[index])
        sender.setImage(playerImage, for: .normal)
        
        if isWinningMove(for: .Human, in: moves) {
            humanScore += 1
            gameOverAlert(title: "Human wins!")
            return
        }
        
        if isDrawGame(in: moves) {
            gameOverAlert(title: "Draw!")
            return
        }

        // computer makes their move...
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let index = self.determineComputerMovePosition(in: self.moves)
            self.moves[index] = Move(player: .Computer, boardIndex: index)
            
            playerImage = self.getPlayerImage(for: self.moves[index])
            self.gameBtns[index].setImage(playerImage, for: .normal)
            
            if self.isWinningMove(for: .Computer, in: self.moves) {
                self.computerScore += 1
                self.gameOverAlert(title: "Computer wins!")
                return
            }
            
            if self.isDrawGame(in: self.moves) {
                self.gameOverAlert(title: "Draw!")
                return
            }
        }
    }
    
    func getPlayerImage(for move: Move?) -> UIImage {
        return UIImage(named: move?.indicator ?? "")!.withTintColor(UIColor(named: "secondaryColor") ?? .lightGray)
    }

    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        let openMoveIndices = moves.indices.filter { moves[$0] == nil }
        return openMoveIndices.randomElement()!
    }
    
    func setupNextGame() {
        let playerImage = UIImage(named: Player.Human.rawValue)!.withTintColor(UIColor(named: "secondaryColor") ?? .lightGray)
        turnImgView.image = playerImage
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
    
    func isDrawGame(in moves: [Move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
    
    func gameOverAlert(title: String) {
        let message = "\nCross \(humanScore) \n\nCircle \(computerScore)"
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Reset", style: .default, handler: { (_) in
            self.resetBoard()
        }))
        present(alertController, animated: true)
        setupNextGame()
    }
    
    func resetBoard() {
        moves = Array(repeating: nil, count: 9)

        for button in gameBtns {
            button.setImage(nil, for: .normal)
        }

        initBoard()
    }
}

enum Player: String {
    case Human = "icCross"
    case Computer = "icCircle"
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player.rawValue
    }
}

