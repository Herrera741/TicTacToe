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
        // Do any additional setup after loading the view.
    }


}
