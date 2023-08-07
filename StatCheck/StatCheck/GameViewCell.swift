//
//  GameViewCell.swift
//  StatCheck
//
//  Created by Yoen Zhang on 2023-07-20.
//

import UIKit

class GameViewCell: UITableViewCell {
    
    enum NBATeam: Int {
        case ATL = 1, BOS, BKN, CHA, CHI, CLE, DAL, DEN, DET, GSW, HOU, IND, LAC, LAL, MEM, MIA, MIL, MIN, NOP, NYK, OKC, ORL, PHI, PHX, POR, SAC, SAS, TOR, UTA, WAS
        
        var abbreviation: String {
            switch self {
            case .ATL: return "ATL"
            case .BOS: return "BOS"
            case .BKN: return "BKN"
            case .CHA: return "CHA"
            case .CHI: return "CHI"
            case .CLE: return "CLE"
            case .DAL: return "DAL"
            case .DEN: return "DEN"
            case .DET: return "DET"
            case .GSW: return "GSW"
            case .HOU: return "HOU"
            case .IND: return "IND"
            case .LAC: return "LAC"
            case .LAL: return "LAL"
            case .MEM: return "MEM"
            case .MIA: return "MIA"
            case .MIL: return "MIL"
            case .MIN: return "MIN"
            case .NOP: return "NOP"
            case .NYK: return "NYK"
            case .OKC: return "OKC"
            case .ORL: return "ORL"
            case .PHI: return "PHI"
            case .PHX: return "PHX"
            case .POR: return "POR"
            case .SAC: return "SAC"
            case .SAS: return "SAS"
            case .TOR: return "TOR"
            case .UTA: return "UTA"
            case .WAS: return "WAS"
            }
        }
        
        static func abbreviation(for id: Int) -> String? {
            return NBATeam(rawValue: id)?.abbreviation
        }
    }


    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    var game: StatsVC.Game? {
        didSet {
            collectionView.reloadData() // Update the collection view when game is set
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MyGameViewCell.self, forCellWithReuseIdentifier: "GameCollectionViewCell") // Corrected cell registration
        
        contentView.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

extension GameViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 21
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCollectionViewCell", for: indexPath) as! MyGameViewCell
        // Use seasonAverageStats to populate the collection view cells
        if let game = game {
            // Access the properties of seasonAverageStats based on indexPath.item
            switch indexPath.item {
            case 0:
                cell.titleLabel.text = "Home -  \(NBATeam.abbreviation(for:  game.game.home_team_id) ?? "Score"): " + "\(game.game.home_team_score)"
                cell.subtitleLabel.text =  "Away -  \(NBATeam.abbreviation(for:  game.game.visitor_team_id) ?? "Score"): " + "\(game.game.visitor_team_score)"
            case 1:
                cell.titleLabel.text = "Date:"
                let date = game.game.date.prefix(10) // Take the first 10 characters of the date string
                cell.subtitleLabel.text = String(date)
            case 2:
                cell.titleLabel.text = "Minutes:"
                cell.subtitleLabel.text = game.min ?? "0"
            case 3:
                cell.titleLabel.text = "Points:"
                cell.subtitleLabel.text = "\(game.pts ?? 0)"
            case 4:
                cell.titleLabel.text = "Assists:"
                cell.subtitleLabel.text = "\(game.ast ?? 0)"
            case 5:
                cell.titleLabel.text = "Rebounds:"
                cell.subtitleLabel.text = "\(game.reb ?? 0)"
            case 6:
                cell.titleLabel.text = "Defensive Rebounds:"
                cell.subtitleLabel.text = "\(game.dreb ?? 0)"
            case 7:
                cell.titleLabel.text = "Offensive Rebounds:"
                cell.subtitleLabel.text = "\(game.oreb ?? 0)"
            case 8:
                cell.titleLabel.text = "Blocks:"
                cell.subtitleLabel.text = "\(game.blk ?? 0)"
            case 9:
                cell.titleLabel.text = "Steals:"
                cell.subtitleLabel.text = "\(game.stl ?? 0)"
            case 10:
                cell.titleLabel.text = "Field Goal Percentage:"
                cell.subtitleLabel.text = String(format: "%.1f", (game.fg_pct ?? 0) * 100) + " %"
            case 11:
                cell.titleLabel.text = "Field Goals Made:"
                cell.subtitleLabel.text = "\(game.fgm ?? 0)"
            case 12:
                cell.titleLabel.text = "Field Goals Attempted:"
                cell.subtitleLabel.text = "\(game.fga ?? 0)"
            case 13:
                cell.titleLabel.text = "Three-Point Percentage:"
                cell.subtitleLabel.text = String(format: "%.1f", (game.fg3_pct ?? 0) * 100) + " %"
            case 14:
                cell.titleLabel.text = "Three-Pointers Made:"
                cell.subtitleLabel.text = "\(game.fg3m ?? 0)"
            case 15:
                cell.titleLabel.text = "Three-Pointers Attempted:"
                cell.subtitleLabel.text = "\(game.fg3a ?? 0)"
            case 16:
                cell.titleLabel.text = "Free Throw Percentage:"
                cell.subtitleLabel.text = String(format: "%.1f", (game.ft_pct ?? 0) * 100) + " %"
            case 17:
                cell.titleLabel.text = "Free Throws Made:"
                cell.subtitleLabel.text = "\(game.ftm ?? 0)"
            case 18:
                cell.titleLabel.text = "Free Throws Attempted:"
                cell.subtitleLabel.text = "\(game.fta ?? 0)"
            case 19:
                cell.titleLabel.text = "Turnovers:"
                cell.subtitleLabel.text = "\(game.turnover ?? 0)"
            case 20:
                cell.titleLabel.text = "Personal Fouls:"
                cell.subtitleLabel.text = "\(game.pf ?? 0)"
            default:
                break
            }

        } else {
            cell.subtitleLabel.text = ""
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width / 2 // Divide width by the number of cells per row
        let cellHeight = collectionView.bounds.height
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

class MyGameViewCell: UICollectionViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 0 // Allow multiple lines of text
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .gray
        label.numberOfLines = 0 // Allow multiple lines of text
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: 10), // Adjust bottom constraint
            
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

}
