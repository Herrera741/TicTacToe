//
//  ViewController.swift
//  TicTacToe
//
//  Created by Sergio Herrera on 3/5/23.
//

import UIKit

class LoadingVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "bgColor")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.showInitialView()
        }
    }
    
    private func showInitialView() {
        performSegue(withIdentifier: "showGame", sender: nil)
    }
}

