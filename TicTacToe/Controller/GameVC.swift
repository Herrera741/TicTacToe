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
    
    func setupFirstTurnImage() {
        let startingPlayerPiece = UIImage(named: Player.Human.rawValue)!.withTintColor(UIColor(named: "secondaryColor") ?? .lightGray)
        turnImgView.image = startingPlayerPiece
    }
    
    func showMenu(winner: String, scores: [Int]) {
        let menuVC = MenuSheetVC(winner: winner, scores: scores, skillLevel: skillLevel)
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
        self.setupFirstTurnImage()
        self.isSinglePlayer = isSinglePlayer
        self.skillLevel = level
    }
    
    // MARK: ibaction for game buttons
    @IBAction func gameBtnTapped(_ sender: UIButton) {
        // human makes their move...
        let index = sender.tag - 1
        if isNotValidMove(in: moves, for: index) { return }
        
        moves[index] = Move(player: .Human, boardIndex: index)
        let humanImage = getPlayerImage(for: .Human)
        sender.setImage(humanImage, for: .normal)
        
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
        let computerImage = getPlayerImage(for: .Computer)
        turnImgView.image = computerImage
        
        let delay = 0.3
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            let index = self.determineComputerPosition(in: self.moves)
            self.moves[index] = Move(player: .Computer, boardIndex: index)
            self.gameBtns[index].setImage(computerImage, for: .normal)
            
            if self.isWinningMove(for: .Computer, in: self.moves) {
                self.scores[1] += 1
                self.showMenu(winner: "AI", scores: self.scores)
                return
            }
            
            if self.isDraw(in: self.moves) {
                self.showMenu(winner: "Draw", scores: self.scores)
                return
            }
            
            self.turnImgView.image = self.getPlayerImage(for: .Human)
        }
    }
    
    // MARK: getter methods
    func getPlayerImage(for player: Player) -> UIImage {
        return UIImage(named: player.rawValue)!.withTintColor(UIColor(named: "secondaryColor") ?? .lightGray)
    }
    
    func getOpenPositions(in moves: [Move?]) -> [Int] {
        moves.indices.filter { moves[$0] == nil }
    }
    
    func getWinPatterns() -> Set<Set<Int>> {
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8],
                                          [0, 3, 6], [1, 4, 7], [2, 5, 8],
                                          [0, 4, 8], [2, 4, 6]]
        
        return winPatterns
    }

    func getRandomPosition(in moves: [Move?]) -> Int {
        let openPositions = getOpenPositions(in: moves)
        return openPositions.randomElement()!
    }
    
    // MARK: game methods
    func isNotValidMove(in moves: [Move?], for index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index })
    }
    
    func isWinningMove(for player: Player, in moves: [Move?]) -> Bool {
        let winPatterns = getWinPatterns()
        
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            if pattern.isSubset(of: playerPositions) {
                return true
            }
        }
        
        return false
    }

    func isDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
    }

    func isOpenPosition(in moves: [Move?], for index: Int) -> Bool {
        return moves[index] == nil
    }
    
    func determineComputerPosition(in moves: [Move?]) -> Int {
        if skillLevel == 3 { return findBestPosition(in: moves) }
        
        if skillLevel == 2 { return findModeratePosition(in: moves) }
        
        // skillLevel = 1
        return getRandomPosition(in: moves)
    }
    
    func findBestPosition(in moves: [Move?]) -> Int {
        let winPosition = findWinPosition(for: .Computer, in: moves)
        if winPosition != -1 { return winPosition }
        
        let blockPosition = findBlockPosition(in: moves)
        if blockPosition != -1 { return blockPosition }
        
        return getRandomPosition(in: moves)
    }
    
    func findModeratePosition(in moves: [Move?]) -> Int {
        let winPosition = findWinPosition(for: .Computer, in: moves)
        let blockPosition = findBlockPosition(in: moves)
        
        if winPosition != -1 && blockPosition != -1 {
            let positions = [winPosition, blockPosition]
            return positions.randomElement()!
        }
        
        return winPosition != -1 ? winPosition : blockPosition != -1 ? blockPosition : getRandomPosition(in: moves)
    }
    
    func findWinPosition(for player: Player, in moves: [Move?]) -> Int {
        let winPatterns = getWinPatterns()
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(playerPositions)
            
            if winPositions.count == 1 {
                if isOpenPosition(in: moves, for: winPositions.first!) { return winPositions.first! }
            }
        }

        return -1
    }
    
    func findBlockPosition(in moves: [Move?]) -> Int {
        let oppWinMove = findWinPosition(for: .Human, in: moves)
        if oppWinMove != -1 { return oppWinMove }
        let centerMove = 4
        if moves[centerMove] == nil { return centerMove }
        
        return -1
    }
}

