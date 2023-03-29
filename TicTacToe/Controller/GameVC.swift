//
//  GameVC.swift
//  TicTacToe
//
//  Created by Sergio Herrera on 3/5/23.
//

import UIKit

// MARK: game enums
enum Player: String {
    case Human = "icCross"
    case Computer = "icCircle"
}

struct Move {
    let player: Player
    let boardIndex: Int
}

class GameVC: UIViewController, MenuSheetDelegate {
    
    // MARK: iboutlets
    @IBOutlet weak var turnLbl: UILabel!
    @IBOutlet weak var turnImgView: UIImageView!
    @IBOutlet weak var vertStackView: UIStackView!
    @IBOutlet var gameBtns: [UIButton]!
    
    // MARK: game variables
    var scores = [0, 0]
    var moves: [Move?] = Array(repeating: nil, count: 9)
    var playerImage = UIImage()
    var isSinglePlayer = false
    var skillLevel = 1
    
    // MARK: initial UI setup
    override func viewDidLoad() {
        super.viewDidLoad()
        initBoard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showMenu(winner: "", scores: self.scores)
    }
    
    // MARK: initial board setup
    func initBoard() {
        self.view.backgroundColor = UIColor(named: "bgColor")
        turnLbl.textColor = UIColor(named: "onBgColor")
        turnImgView.backgroundColor = UIColor(named: "bgColor")
        turnImgView.image = UIImage(named: Player.Human.rawValue)?.withTintColor(UIColor(named: "secondaryColor") ?? .lightGray)
        vertStackView.backgroundColor = UIColor(named: "overlayRed")
        
        for button in gameBtns {
            button.backgroundColor = UIColor(named: "surfaceColor")
        }
    }
    
    func resetBoard() {
        moves = Array(repeating: nil, count: 9)
        
        for button in gameBtns {
            button.setImage(nil, for: .normal)
        }
        
        initBoard()
    }
    
    func setupNextGame() {
        let playerImage = UIImage(named: Player.Human.rawValue)!.withTintColor(UIColor(named: "secondaryColor") ?? .lightGray)
        turnImgView.image = playerImage
    }
    
    func showMenu(winner: String, scores: [Int]) {
        let menuVC = MenuSheetVC(winner: winner, scores: scores)
        menuVC.delegate = self
        if let sheet = menuVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        
        present(menuVC, animated: true, completion: nil)
    }
    
    // MARK: delegate protocol communication
    func didTapPlayButton(isSinglePlayer: Bool, level: Int) {
        self.resetBoard()
        self.setupNextGame()
        self.isSinglePlayer = isSinglePlayer
        self.skillLevel = level
    }
    
    // MARK: ibactions
    @IBAction func gameBtnTapped(_ sender: UIButton) {
        // human makes their move...
        let index = sender.tag - 1
        if notValidMove(in: moves, for: index) { return }
        moves[index] = Move(player: .Human, boardIndex: index)
        playerImage = getPlayerImage(for: .Human)
        sender.setImage(playerImage, for: .normal)
        
        if isWinningMove(for: .Human, in: moves) {
            self.scores[0] += 1
            self.showMenu(winner: "You", scores: self.scores)
            return
        }
        
        if isDraw(in: moves) {
            self.showMenu(winner: "Draw", scores: self.scores)
            return
        }
        
        // computer makes their move...
        playerImage = getPlayerImage(for: .Computer)
        turnImgView.image = playerImage
        
        let delay = self.skillLevel == 1 ? 0.2 : 1
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            let index = self.determineComputerMove(in: self.moves)
            self.moves[index] = Move(player: .Computer, boardIndex: index)
            self.gameBtns[index].setImage(self.playerImage, for: .normal)
            
            if self.isWinningMove(for: .Computer, in: self.moves) {
                self.scores[1] += 1
                self.showMenu(winner: "AI", scores: self.scores)
                return
            }
            
            if self.isDraw(in: self.moves) {
                self.showMenu(winner: "Draw", scores: self.scores)
                return
            }
            
            self.playerImage = self.getPlayerImage(for: .Human)
            self.turnImgView.image = self.playerImage
        }
    }
    
    // MARK: game methods
    func getPlayerImage(for player: Player) -> UIImage {
        return UIImage(named: player.rawValue)!.withTintColor(UIColor(named: "secondaryColor") ?? .lightGray)
    }
    
    func notValidMove(in moves: [Move?], for index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index })
    }
    
    // MARK: game state methods
    func getWinPatterns() -> [[Int]] {
        let horizPatterns = [[0, 1, 2], [3, 4, 5], [6, 7, 8]]
        let vertPatterns = [[0, 3, 6], [1, 4, 7], [2, 5, 8]]
        let diagPatterns = [[0, 4, 8], [2, 4, 6]]
        return horizPatterns + vertPatterns + diagPatterns
    }
    
    func isWinningMove(for player: Player, in moves: [Move?]) -> Bool {
        let winPatterns = getWinPatterns()
        
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

    func isDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
    
    func getOpenMoves(in moves: [Move?]) -> [Int] {
        var indices = [Int]()
        let numberOfMoves = moves.count
        for idx in 0..<numberOfMoves {
            if moves[idx] == nil {
                indices.append(idx)
            }
        }
        
        return indices
    }
    
    func determineComputerMove(in moves: [Move?]) -> Int {
        if skillLevel == 3 { return findBestMove(in: moves) }
        
        if skillLevel == 2 { return findModerateMove(in: moves) }
        
        // skillLevel = 1
        return getRandomMove(in: moves)
    }
    
    func findBestMove(in moves: [Move?]) -> Int {
        let winMove = findWinningMove(for: .Computer, in: moves)
        if winMove != -1 { return winMove }
        
        let blockMove = findBlockingMove(in: moves)
        if blockMove != -1 { return blockMove }
        
        return getRandomMove(in: moves)
    }
    
    func findModerateMove(in moves: [Move?]) -> Int {
        let winMove = findWinningMove(for: .Computer, in: moves)
        let blockMove = findBlockingMove(in: moves)
        
        if winMove != -1 && blockMove != -1 {
            let choices = [winMove, blockMove]
            return choices.randomElement()!
        }
        
        return winMove != -1 ? winMove : blockMove != -1 ? blockMove : getRandomMove(in: moves)
    }
    
    func getRandomMove(in moves: [Move?]) -> Int {
        let openMoveIndices = moves.indices.filter { moves[$0] == nil }
        return openMoveIndices.randomElement()!
    }
    
    func findWinningMove(for player: Player, in moves: [Move?]) -> Int {
        let winPatterns = getWinPatterns()
        let openMoves = getOpenMoves(in: moves)
        
        for openMove in openMoves {
            for pattern in winPatterns {
                let closedMoves = pattern.filter { idx in
                    return idx != openMove
                }
                
                if closedMoves.count == 2 {
                    var lineMoveCount = 0
                    for move in closedMoves {
                        if moves[move]?.player == player {
                            lineMoveCount += 1
                        }
                        
                        if lineMoveCount == 2 { return openMove }
                    }
                }
            }
        }
        
        return -1
    }
    
    func findBlockingMove(in moves: [Move?]) -> Int {
        let oppWinMove = findWinningMove(for: .Human, in: moves)
        if oppWinMove != -1 { return oppWinMove }
        let centerMove = 4
        if moves[centerMove] == nil { return centerMove }
        
        let winPatterns = getWinPatterns()
        let openMoves = getOpenMoves(in: moves)
        
        for openMove in openMoves {
            for pattern in winPatterns {
                let closedMoves = pattern.filter { idx in
                    return idx != openMove
                }

                if closedMoves.count == 1 {
                    let closedMove = closedMoves[0]
                    if moves[closedMove]?.player == .Human {
                        let openLineMoves = pattern.filter { idx in
                            return idx != closedMove
                        }
                        
                        return openLineMoves.randomElement()!
                    }
                }
            }
        }
        
        return -1
    }
}

