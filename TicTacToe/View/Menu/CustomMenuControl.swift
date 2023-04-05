//
//  CustomMenuControl.swift
//  TicTacToe
//
//  Created by Sergio Herrera on 4/5/23.
//

import UIKit

class CustomMenuControl: UISegmentedControl {
    
    override init(items: [Any]? = []) {
        super.init(items: items)
        self.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        self.selectedSegmentIndex = 0
        self.selectedSegmentTintColor = .systemTeal
        self.backgroundColor = .systemGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
