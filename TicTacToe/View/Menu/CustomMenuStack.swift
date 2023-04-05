//
//  CustomMenuStack.swift
//  TicTacToe
//
//  Created by Sergio Herrera on 4/5/23.
//

import UIKit

class CustomMenuStack: UIStackView {
    
    init(axis: NSLayoutConstraint.Axis = .horizontal, distribution: Distribution = .fill, spacing: CGFloat = 15, alignment: Alignment = .center, isHidden: Bool = false) {
        super.init(frame: .zero)
        self.axis = axis
        self.distribution = distribution
        self.spacing = spacing
        self.alignment = alignment
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
