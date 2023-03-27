//
//  MenuSheetVC.swift
//  TicTacToe
//
//  Created by Sergio Herrera on 3/15/23.
//

import UIKit

protocol MenuSheetDelegate {
    func didTapPlayButton(singleMode: Bool, level: Int)
}

class MenuSheetVC: UIViewController {
    
    // MARK: uiview variables
    var titleLabel = UILabel()
    var labelsSV = UIStackView()
    var modesSV = UIStackView()
    var skillLevelsSV = UIStackView()
    var playButton = UIButton()
    
    // MARK: game variables
    var winner = ""
    var scores = [0, 0]
    var players = ["Human", "AI"]
    var isSinglePlayer = true
    var skillLevel = 0
    var delegate: MenuSheetDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "surfaceColor")
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            delegate?.didTapPlayButton(singleMode: isSinglePlayer, level: skillLevel)
        }
    }
    
    init(winner: String, scores: [Int]) {
        self.winner = winner
        self.scores = scores
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        configTitleLabel()
        
        if !winner.isEmpty {
            configLabelsSV()
        }
        
        configModesSV()
        configSkillLevelsSV()
        configButton()
    }
    
    // MARK: title ui
    func configTitleLabel() {
        view.addSubview(titleLabel)
        
        titleLabel.text = getTitleLabelText(title: winner)
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 28, weight: .heavy)
        titleLabel.textAlignment = .center
        
        setTitleLabelConstraints()
    }
    
    func getTitleLabelText(title: String) -> String {
        switch title {
        case "You":
            return "\(title) Win!"
        case "AI":
            return "\(title) Wins!"
        case "Draw":
            return "It's a \(title)"
        default:
            return "Tic Tac Toe"
        }
    }
    
    func setTitleLabelConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    // MARK: labels ui
    func configLabelsSV() {
        view.addSubview(labelsSV)
        
        labelsSV.axis = .vertical
        labelsSV.distribution = .fill
        labelsSV.spacing = 5
        labelsSV.alignment = .trailing
        labelsSV.isHidden = winner == "" ? true : false
        
        addToLabelsSV()
        setLabelsSVConstraints()
    }
    
    func addToLabelsSV() {
        let numberOfLabels = 2
        
        for index in 0..<numberOfLabels {
            let label = MenuLabel()
            label.text = "\(players[index]) Score: \(scores[index])"
            labelsSV.addArrangedSubview(label)
        }
    }
    
    func setLabelsSVConstraints() {
        labelsSV.translatesAutoresizingMaskIntoConstraints = false
        labelsSV.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 35).isActive = true
        labelsSV.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor).isActive = true
    }
    
    // MARK: modes ui
    func configModesSV() {
        view.addSubview(modesSV)
        
        modesSV.axis = .horizontal
        modesSV.distribution = .fill
        modesSV.spacing = 15
        
        addToModesSV()
        setModesSVConstraints()
    }
    
    func addToModesSV() {
        let modeLabel = UILabel()
        modeLabel.text = "Mode:"
        modeLabel.font = UIFont.systemFont(ofSize: 20)
        modeLabel.textAlignment = .right
        modeLabel.textColor = .white
        modeLabel.translatesAutoresizingMaskIntoConstraints = false
        modeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        let modeControl = UISegmentedControl(
            items: [UIImage(systemName: "person.fill") ?? "",
                    UIImage(systemName: "person.2.fill") ?? ""])
        modeControl.addTarget(self, action: #selector(modeDidChange), for: .valueChanged)
        modeControl.selectedSegmentIndex = isSinglePlayer ? 0 : 1
        modeControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        modeControl.selectedSegmentTintColor = .systemTeal
        modeControl.backgroundColor = .systemGray
        modeControl.translatesAutoresizingMaskIntoConstraints = false
        modeControl.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        modesSV.addArrangedSubview(modeLabel)
        modesSV.addArrangedSubview(modeControl)
    }
    
    @objc func modeDidChange(_ segmentedControl: UISegmentedControl) {
        isSinglePlayer.toggle()
    }
    
    func setModesSVConstraints() {
        modesSV.translatesAutoresizingMaskIntoConstraints = false
        modesSV.topAnchor.constraint(equalTo: winner.isEmpty ? titleLabel.bottomAnchor : labelsSV.bottomAnchor, constant: winner.isEmpty ? CGFloat(50) : CGFloat(25)).isActive = true
        modesSV.centerXAnchor.constraint(equalTo: winner.isEmpty ? titleLabel.centerXAnchor : labelsSV.centerXAnchor).isActive = true
    }
    
    // MARK: skill levels ui
    func configSkillLevelsSV() {
        view.addSubview(skillLevelsSV)
        
        skillLevelsSV.axis = .horizontal
        skillLevelsSV.distribution = .fill
        skillLevelsSV.spacing = 15
        
        addToSkillLevelsSV()
        setSkillLevelsSVConstraints()
    }
    
    func addToSkillLevelsSV() {
        let modeLevel = UILabel()
        modeLevel.text = "Skill Level:"
        modeLevel.font = UIFont.systemFont(ofSize: 20)
        modeLevel.textAlignment = .right
        modeLevel.textColor = .white
        modeLevel.translatesAutoresizingMaskIntoConstraints = false
        modeLevel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        let modeControl = UISegmentedControl(items: ["Easy", "Medium", "Hard"])
        modeControl.addTarget(self, action: #selector(skillDidChange), for: .valueChanged)
        modeControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        modeControl.selectedSegmentIndex = 0
        modeControl.selectedSegmentTintColor = .systemTeal
        modeControl.backgroundColor = .systemGray
        modeControl.translatesAutoresizingMaskIntoConstraints = false
        modeControl.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        skillLevelsSV.addArrangedSubview(modeLevel)
        skillLevelsSV.addArrangedSubview(modeControl)
    }
    
    @objc func skillDidChange(_ segmentedControl: UISegmentedControl) {
        skillLevel = segmentedControl.selectedSegmentIndex
    }
    
    func setSkillLevelsSVConstraints() {
        skillLevelsSV.translatesAutoresizingMaskIntoConstraints = false
        skillLevelsSV.topAnchor.constraint(equalTo: modesSV.bottomAnchor, constant: 10).isActive = true
        skillLevelsSV.centerXAnchor.constraint(equalTo: modesSV.centerXAnchor).isActive = true
    }
    
    // MARK: play button ui
    func configButton() {
        view.addSubview(playButton)
        
        playButton.setTitle(winner == "" ? "Play" : "Play Again", for: .normal)
        playButton.setTitleColor(.white, for: .normal)
        playButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        playButton.configuration = .filled()
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)

        setPlayButtonConstraints()
    }
    
    @objc func playButtonTapped() {
        delegate?.didTapPlayButton(singleMode: isSinglePlayer, level: skillLevel)
        dismiss(animated: true)
    }
    
    func setPlayButtonConstraints() {
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.topAnchor.constraint(equalTo: skillLevelsSV.bottomAnchor, constant: 50).isActive = true
        playButton.centerXAnchor.constraint(equalTo: skillLevelsSV.centerXAnchor).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 230).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
