//
//  MenuView.swift
//  TicTacToe
//
//  Created by Sergio Herrera on 4/5/23.
//

import UIKit

class MenuView: UIView {

    // MARK: subview initializations
    var titleLabel = CustomMenuLabel(text: "Tic Tac Toe",
                                     textAlignment: .center,
                                     font: .systemFont(ofSize: 35, weight: .heavy))

    let playerOneScoreLabel = CustomMenuLabel(text: "Player 1 Score: 0")
    let playerTwoScoreLabel = CustomMenuLabel(text: "Player 2 Score: 0")
    let scoresSV = CustomMenuStack(axis: .vertical,
                                   spacing: 5,
                                   alignment: .center)
    
    let modeLabel = CustomMenuLabel(text: "Mode", textAlignment: .right)
    let playerModeControl = CustomMenuControl(
        items:[
            UIImage(systemName: "person.fill") ?? "",
            UIImage(systemName: "person.2.fill") ?? ""
        ])
    let modesSV = CustomMenuStack()
    
    let skillLevelLabel = CustomMenuLabel(text: "Skill Level", textAlignment: .right)
    let skillLevelControl = CustomMenuControl(items: ["Easy", "Medium", "Hard"])
    let skillLevelsSV = CustomMenuStack()

    var playButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.setTitle("Play", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        return button
    }()

    // MARK: class initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: view setup
    func setupUI() {
        self.backgroundColor = UIColor(named: "surfaceColor")
        addSubviews()
        addSubviewConstraints()
    }
    
    func addSubviews() {
        // lower-level subviews
        scoresSV.addArrangedSubview(playerOneScoreLabel)
        scoresSV.addArrangedSubview(playerTwoScoreLabel)
        modesSV.addArrangedSubview(modeLabel)
        modesSV.addArrangedSubview(playerModeControl)
        skillLevelsSV.addArrangedSubview(skillLevelLabel)
        skillLevelsSV.addArrangedSubview(skillLevelControl)

        // top-level subviews
        self.addSubview(titleLabel)
        self.addSubview(scoresSV)
        self.addSubview(modesSV)
        self.addSubview(skillLevelsSV)
        self.addSubview(playButton)
    }

    func addSubviewConstraints() {
        let subviews = [titleLabel, scoresSV, modeLabel, modesSV, skillLevelLabel, skillLevelsSV, playButton]
        for subview in subviews {
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 50),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 300),

            scoresSV.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 35),
            scoresSV.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            scoresSV.widthAnchor.constraint(equalToConstant: 300),

            modeLabel.widthAnchor.constraint(equalToConstant: 100),
            modesSV.topAnchor.constraint(equalTo: scoresSV.bottomAnchor, constant: 30),
            modesSV.centerXAnchor.constraint(equalTo: scoresSV.centerXAnchor),
            modesSV.widthAnchor.constraint(equalToConstant: 330),

            skillLevelLabel.widthAnchor.constraint(equalToConstant: 100),
            skillLevelsSV.topAnchor.constraint(equalTo: modesSV.bottomAnchor, constant: 10),
            skillLevelsSV.centerXAnchor.constraint(equalTo: modesSV.centerXAnchor),
            skillLevelsSV.widthAnchor.constraint(equalToConstant: 330),

            playButton.topAnchor.constraint(equalTo: skillLevelsSV.bottomAnchor, constant: 50),
            playButton.centerXAnchor.constraint(equalTo: skillLevelsSV.centerXAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 230),
            playButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
