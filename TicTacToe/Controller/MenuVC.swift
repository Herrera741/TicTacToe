//
//  MenuVC.swift
//  TicTacToe
//
//  Created by Sergio Herrera on 3/15/23.
//

import UIKit

class MenuVC: UIViewController {
    
    // MARK: menu view variables
    let menuView = MenuView(frame: UIScreen.main.bounds)
    var delegate: MenuViewDelegate?
    
    // MARK: game declarations
    var titleText: String = "You Win!"
    var scores: [Int] = [0, 0]
//    var players = ["Human", "AI"]

    // MARK: class view lifecycle methods
    override func viewDidLoad() {
        view.backgroundColor = .blue
        self.view = menuView
        hideLabelsOnFirstGame()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            delegate?.didTapPlayButton(playerMode: menuView.playerModeControl.selectedSegmentIndex, skillLevel: menuView.skillLevelControl.selectedSegmentIndex)
        }
    }
    
    // MARK: menu labels check
    func hideLabelsOnFirstGame() {
        let isFirstGame = scores[0] == 0 && scores[1] == 0
        if isFirstGame {
            self.menuView.labelsSV.subviews[0].isHidden = true
            self.menuView.labelsSV.subviews[1].isHidden = true
            self.menuView.labelsSV.isHidden = true
        }
    }
}
