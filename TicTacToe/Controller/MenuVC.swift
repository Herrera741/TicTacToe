//
//  MenuVC.swift
//  TicTacToe
//
//  Created by Sergio Herrera on 3/15/23.
//

import UIKit

struct MenuSelection {
    var mode: Int
    var skill: Int
}

class MenuVC: UIViewController {

    // MARK: view instances
    let menuView = MenuView()
    var menuVM = MenuVM()

    // MARK: class view lifecycle methods
    override func viewDidLoad() {
        view.backgroundColor = .blue
        view = menuView
        updateMenu()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            sendMenuSelectionToMenuVM()
        }
    }
    
    // MARK: update menu with data
    func updateMenu() {
        if menuVM.isFirstGame {
            menuView.playerOneScoreLabel.isHidden = true
            menuView.playerTwoScoreLabel.isHidden = true
            menuView.scoresSV.isHidden = true
        }
        
        menuView.titleLabel.text = menuVM.titleText
        configPlayButton()
    }
    
    // MARK: event listener
    func configPlayButton() {
        menuView.playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
    }
                             
    @objc func playButtonTapped() {
        sendMenuSelectionToMenuVM()
        dismiss(animated: true)
    }
    
    func sendMenuSelectionToMenuVM() {
        let menuSelection = MenuSelection(
            mode: menuView.playerModeControl.selectedSegmentIndex,
            skill: menuView.skillLevelControl.selectedSegmentIndex)
        menuVM.menuSelection = menuSelection
    }
}
