import UIKit

class TableViewCell: UITableViewCell {
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    var seasonAverageStats: StatsVC.AllSeasonStats? {
        didSet {
            collectionView.reloadData() // Update the collection view when stats are set
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
        collectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        
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

extension TableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 21
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! MyCollectionViewCell
        // Use seasonAverageStats to populate the collection view cells
        if let seasonStats = seasonAverageStats {
            // Access the properties of seasonAverageStats based on indexPath.item
            switch indexPath.item {
            case 0:
                cell.titleLabel.text = "Games Played:"
                cell.subtitleLabel.text = "\(seasonStats.games_played)"
            case 1:
                cell.titleLabel.text = "Minutes:"
                cell.subtitleLabel.text = seasonStats.min
            case 2:
                cell.titleLabel.text = "Points:"
                cell.subtitleLabel.text = "\(seasonStats.pts)"
            case 3:
                cell.titleLabel.text = "Assists:"
                cell.subtitleLabel.text = "\(seasonStats.ast)"
            case 4:
                cell.titleLabel.text = "Rebounds:"
                cell.subtitleLabel.text = "\(seasonStats.reb)"
            case 5:
                cell.titleLabel.text = "Defensive Rebounds:"
                cell.subtitleLabel.text = "\(seasonStats.dreb)"
            case 6:
                cell.titleLabel.text = "Offensive Rebounds:"
                cell.subtitleLabel.text = "\(seasonStats.oreb)"
            case 7:
                cell.titleLabel.text = "Blocks:"
                cell.subtitleLabel.text = "\(seasonStats.blk)"
            case 8:
                cell.titleLabel.text = "Steals:"
                cell.subtitleLabel.text = "\(seasonStats.stl)"
            case 9:
                cell.titleLabel.text = "Field Goal Percentage:"
                cell.subtitleLabel.text = String(format: "%.1f", seasonStats.fg_pct * 100) + " %"
            case 10:
                cell.titleLabel.text = "Field Goals Made:"
                cell.subtitleLabel.text = "\(seasonStats.fgm)"
            case 11:
                cell.titleLabel.text = "Field Goals Attempted:"
                cell.subtitleLabel.text = "\(seasonStats.fga)"
            case 12:
                cell.titleLabel.text = "Three-Point Percentage:"
                cell.subtitleLabel.text = String(format: "%.1f", seasonStats.fg3_pct * 100) + " %"
            case 13:
                cell.titleLabel.text = "Three-Pointers Made:"
                cell.subtitleLabel.text = "\(seasonStats.fg3m)"
            case 14:
                cell.titleLabel.text = "Three-Pointers Attempted:"
                cell.subtitleLabel.text = "\(seasonStats.fg3a)"
            case 15:
                cell.titleLabel.text = "Free Throw Percentage:"
                cell.subtitleLabel.text = "\(seasonStats.ft_pct * 100)"
            case 16:
                cell.titleLabel.text = "Free Throws Made:"
                cell.subtitleLabel.text = String(format: "%.1f", seasonStats.ft_pct * 100) + " %"
            case 17:
                cell.titleLabel.text = "Free Throws Attempted:"
                cell.subtitleLabel.text = "\(seasonStats.fta)"
            case 18:
                cell.titleLabel.text = "Turnovers:"
                cell.subtitleLabel.text = "\(seasonStats.turnover)"
            case 19:
                cell.titleLabel.text = "Personal Fouls:"
                cell.subtitleLabel.text = "\(seasonStats.pf)"
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

class MyCollectionViewCell: UICollectionViewCell {
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
