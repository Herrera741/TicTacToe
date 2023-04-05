//
//  MenuVC.swift
//  TicTacToe
//
//  Created by Sergio Herrera on 3/15/23.
//

import UIKit

protocol MenuSheetDelegate {
    func didTapPlayButton(isSinglePlayer: Bool, level: Int)
}

class MenuVC: UIViewController {
    
    // MARK: uiview variables
    var titleLabel = CustomMenuLabel(text: "You Win!",
                                     textAlignment: .center,
                                     font: .systemFont(ofSize: 28, weight: .heavy))
    
    var modeControl = CustomMenuControl()
    var labelsSV = CustomMenuStack(axis: .vertical, spacing: 5, alignment: .trailing)
    var modesSV = CustomMenuStack()
    var skillLevelsSV = CustomMenuStack()
    var playButton = UIButton()
    
    // MARK: game variables
    var winner: String = "you win!"
    var scores: [Int] = [0, 0]
    var players = ["Human", "AI"]
    var singlePlayerMode = true
    var skillLevel: Int = 0
    var delegate: MenuSheetDelegate?
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "surfaceColor")
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            delegate?.didTapPlayButton(isSinglePlayer: singlePlayerMode, level: skillLevel)
            print("MenuVC was dismissed")
        }
    }
    
    func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(labelsSV)
        view.addSubview(modesSV)
        view.addSubview(skillLevelsSV)
        view.addSubview(playButton)
        
        configLabelsSV()
        configModesSV()
        configSkillLevelsSV()
        configButton()
        
        addConstraints()
    }
    
    // MARK: title ui
    func getTitleLabelText(title: String) -> String {
        switch title {
        case "You":
            return "\(title) Win!"
        case "AI":
            return "\(title) Wins!"
        case "Draw":
            return "It's a \(title)!"
        default:
            return "Tic Tac Toe"
        }
    }

    // MARK: labels ui
    func configLabelsSV() {
        addToLabelsSV()
    }
    
    func addToLabelsSV() {
        let numberOfLabels = 2
        
        for index in 0..<numberOfLabels {
            let label = CustomMenuLabel(text: "\(players[index]) Score: \(scores[index])")
            labelsSV.addArrangedSubview(label)
        }
        
        labelsSV.isHidden = true
    }
    
    // MARK: modes ui
    func configModesSV() {
        addToModesSV()
    }
    
    func addToModesSV() {
        let modeLabel = CustomMenuLabel(text: "Mode:")
        modeLabel.translatesAutoresizingMaskIntoConstraints = false
        modeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        let items: [Any] = [UIImage(systemName: "person.fill") ?? "", UIImage(systemName: "person.2.fill") ?? ""]
        let modeControl = CustomMenuControl(items: items)
        modeControl.translatesAutoresizingMaskIntoConstraints = false
        modeControl.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        modesSV.addArrangedSubview(modeLabel)
        modesSV.addArrangedSubview(modeControl)
    }
    
    func setModesSVConstraints() {
        modesSV.translatesAutoresizingMaskIntoConstraints = false
        modesSV.topAnchor.constraint(equalTo: winner.isEmpty ? titleLabel.bottomAnchor : labelsSV.bottomAnchor, constant: winner.isEmpty ? CGFloat(50) : CGFloat(25)).isActive = true
        modesSV.centerXAnchor.constraint(equalTo: winner.isEmpty ? titleLabel.centerXAnchor : labelsSV.centerXAnchor).isActive = true
    }
    
    // MARK: skill levels ui
    func configSkillLevelsSV() {
        addToSkillLevelsSV()
    }
    
    func addToSkillLevelsSV() {
        let modeLevel = CustomMenuLabel(text: "Skill Level:")
        modeLevel.translatesAutoresizingMaskIntoConstraints = false
        modeLevel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        let modeControl = CustomMenuControl(items: ["Easy", "Medium", "Hard"])
        modeControl.translatesAutoresizingMaskIntoConstraints = false
        modeControl.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        skillLevelsSV.addArrangedSubview(modeLevel)
        skillLevelsSV.addArrangedSubview(modeControl)
    }
    
    // MARK: play button ui
    func configButton() {
        playButton.setTitle(winner == "" ? "Play" : "Play Again", for: .normal)
        playButton.setTitleColor(.white, for: .normal)
        playButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        playButton.configuration = .filled()
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
    }
    
    @objc func playButtonTapped() {
        delegate?.didTapPlayButton(isSinglePlayer: singlePlayerMode, level: skillLevel)
        dismiss(animated: true)
    }
    
    func addConstraints() {
        let subViews = [titleLabel, labelsSV, modesSV, skillLevelsSV, playButton]
        for subView in subViews {
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let isFirstGame = scores[0] == 0 && scores[1] == 0
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: isFirstGame ? 80 : 50),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            labelsSV.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 35),
            labelsSV.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),

            modesSV.topAnchor.constraint(equalTo: isFirstGame ? titleLabel.bottomAnchor : labelsSV.bottomAnchor, constant: 40),
            modesSV.centerXAnchor.constraint(equalTo: labelsSV.centerXAnchor),

            skillLevelsSV.topAnchor.constraint(equalTo: modesSV.bottomAnchor, constant: 10),
            skillLevelsSV.centerXAnchor.constraint(equalTo: modesSV.centerXAnchor),

            playButton.topAnchor.constraint(equalTo: skillLevelsSV.bottomAnchor, constant: 50),
            playButton.centerXAnchor.constraint(equalTo: skillLevelsSV.centerXAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 230),
            playButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
