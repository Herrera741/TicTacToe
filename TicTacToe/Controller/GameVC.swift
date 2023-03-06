//
//  GameVC.swift
//  TicTacToe
//
//  Created by Sergio Herrera on 3/5/23.
//

import UIKit

class GameVC: UIViewController {
    
    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet weak var gameBoardBtn1: UIButton!
    @IBOutlet weak var gameBoardBtn2: UIButton!
    @IBOutlet weak var gameBoardBtn3: UIButton!
    @IBOutlet weak var gameBoardBtn4: UIButton!
    @IBOutlet weak var gameBoardBtn5: UIButton!
    @IBOutlet weak var gameBoardBtn6: UIButton!
    @IBOutlet weak var gameBoardBtn7: UIButton!
    @IBOutlet weak var gameBoardBtn8: UIButton!
    @IBOutlet weak var gameBoardBtn9: UIButton!

    var playerTurn = "X"
    var board = [UIButton]()

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
        
        if isFullBoard() {
            gameOverAlert(title: "Draw")
        }
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
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
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
