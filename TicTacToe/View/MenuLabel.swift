//
//  MenuLabel.swift
//  TicTacToe
//
//  Created by Sergio Herrera on 3/24/23.
//

import UIKit

class MenuLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLabel()
    }
    
    func setupLabel() {
        textColor = .systemGray5
        backgroundColor = UIColor(named: "surfaceColor")
        font = .systemFont(ofSize: 20, weight: .medium)
    }
    
}
