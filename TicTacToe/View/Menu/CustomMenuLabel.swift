//
//  CustomMenuLabel.swift
//  TicTacToe
//
//  Created by Sergio Herrera on 3/24/23.
//

import UIKit

class CustomMenuLabel: UILabel {
    
    required init(text: String = "", textColor: UIColor = .systemGray5, textAlignment: NSTextAlignment = .right, font: UIFont = .systemFont(ofSize: 20)) {
        super.init(frame: .zero)
        self.text = text
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.font = font
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
