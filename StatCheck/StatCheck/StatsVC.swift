//
//  StatsVC.swift
//  StatCheck
//
//  Created by Yoen Zhang on 2023-07-19.
//

import UIKit

class StatsVC: UIViewController {

    @IBOutlet var seasonAvgTable: UITableView!
    @IBOutlet var regularSeasonGamesTable: UITableView!
    @IBOutlet var playoffGamesTable: UITableView!
    var id: Int?
    var selectedValue: String = ""
    var selectedRegularValue: String = "2022"
    var selectedPlayoffValue: String = "2022"
    var selectedPickerRow: Int = 2022 // Store the selected row here
    var selectedRegularPickerRow: Int = 2022
    var selectedPlayoffPickerRow: Int = 2022
    var regularSeasonLabel: UILabel!
    var playoffLabel: UILabel!
    var didGetPlayerStats: Int = 0

    struct AllSeasonStats: Decodable {
        var games_played: Int
        var min: String
        var pts: Double
        var ast: Double
        var reb: Double
        var dreb: Double
        var oreb: Double
        var blk: Double
        var stl: Double
        var fg_pct: Double
        var fgm: Double
        var fga: Double
        var fg3_pct: Double
        var fg3m: Double
        var fg3a: Double
        var ft_pct: Double
        var ftm: Double
        var fta: Double
        var turnover: Double
        var pf: Double
        var season: Int
    }
    
    struct Game: Decodable {
        var min: String?
        var pts: Int?
        var ast: Int?
        var reb: Int?
        var dreb: Int?
        var oreb: Int?
        var blk: Int?
        var stl: Int?
        var fg_pct: Double?
        var fgm: Int?
        var fga: Int?
        var fg3_pct: Double?
        var fg3m: Int?
        var fg3a: Int?
        var ft_pct: Double?
        var ftm: Int?
        var fta: Int?
        var turnover: Int?
        var pf: Int?
        var game: GameInfo
    }
    
    struct GameInfo: Decodable {
        let id: Int
        let date: String
        let home_team_id: Int
        let home_team_score: Int
        let visitor_team_id: Int
        let visitor_team_score: Int
        let postseason: Bool
    }
    
    var regularSeasonGames: [Game] = []
    var postSeasonGames: [Game] = []
    var seasonAverageStats = AllSeasonStats(games_played: 0, min: "0", pts: 0.0, ast: 0.0, reb: 0.0, dreb: 0.0, oreb: 0.0, blk: 0.0, stl: 0.0, fg_pct: 0.0, fgm: 0.0, fga: 0.0, fg3_pct: 0.0, fg3m: 0.0, fg3a: 0.0, ft_pct: 0.0, ftm: 0.0, fta: 0.0, turnover: 0.0, pf: 0.0, season: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Player Stats"
        seasonAvgTable.dataSource = self
        seasonAvgTable.delegate = self
        regularSeasonGamesTable.dataSource = self
        regularSeasonGamesTable.delegate = self
        playoffGamesTable.dataSource = self
        playoffGamesTable.delegate = self
        seasonAvgTable.tag = 1
        regularSeasonGamesTable.tag = 2
        playoffGamesTable.tag = 3
        getPlayerStats()
        getRegularSeasonGames()
        getPlayoffGames()
        // Add Auto Layout constraints for the table views and labels
        setupViews()
    }
    
    // Function to set up Auto Layout constraints for the table views and labels
    private func setupViews() {
        // Constrain seasonAvgTable to the top safe area
        seasonAvgTable.translatesAutoresizingMaskIntoConstraints = false
        seasonAvgTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        seasonAvgTable.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        seasonAvgTable.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        seasonAvgTable.heightAnchor.constraint(equalToConstant: 180).isActive = true

        // Constrain playoffGamesTable to the bottom safe area
        playoffGamesTable.translatesAutoresizingMaskIntoConstraints = false
        playoffGamesTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        playoffGamesTable.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playoffGamesTable.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        playoffGamesTable.heightAnchor.constraint(equalToConstant: 180).isActive = true
        
        // Constrain regularSeasonGamesTable to be in the middle of seasonAvgTable and playoffGamesTable
        regularSeasonGamesTable.translatesAutoresizingMaskIntoConstraints = false
        regularSeasonGamesTable.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40).isActive = true
        regularSeasonGamesTable.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        regularSeasonGamesTable.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        regularSeasonGamesTable.heightAnchor.constraint(equalToConstant: 180).isActive = true
    }

    
    func getPlayerStats() {
        var seasonAverageURL = URL(string: "https://www.balldontlie.io/api/v1/season_averages?player_ids[]=" + "\(id!)")!
        
        if selectedValue != "" {
            seasonAverageURL = URL(string: "https://www.balldontlie.io/api/v1/season_averages?player_ids[]=" + "\(id!)" + "&season=" + selectedValue)!
        }
        //print(seasonAverageURL)

        let task = URLSession.shared.dataTask(with: seasonAverageURL) { [weak self] (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any],
                   let dataArray = jsonResponse["data"] as? [[String: Any]] {
                    // Print the JSON response for debugging
                    //print(jsonResponse)

                    // Decode the JSON array into an array of AllSeasonStats structs
                    let decoder = JSONDecoder()
                    let jsonData = try JSONSerialization.data(withJSONObject: dataArray, options: [])
                    let allSeasonStatsArray = try decoder.decode([AllSeasonStats].self, from: jsonData)
                    
                    // Use the decoded array of structs as needed
                    if let stats = allSeasonStatsArray.first {
                        // Update the seasonAverageStats property with the new data
                        self?.seasonAverageStats = stats
                        self?.didGetPlayerStats += 1
                        
                        if (self?.didGetPlayerStats != 0) {
                            self?.getRegularSeasonGames()
                            self?.getPlayoffGames()
                        }
                        // Find the index path for the specific cell
                        let indexPath = IndexPath(row: 0, section: 0) // Update with the correct row and section
                        DispatchQueue.main.async {
                            // Reload only the specific cell
                            self?.seasonAvgTable.reloadRows(at: [indexPath], with: .automatic)
                        }
                    } else {
                        print("Invalid JSON format or array not found")
                    }
                } else {
                    print("Invalid JSON format or array not found")
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        task.resume()
    }
    
    func getRegularSeasonGames() {
        if seasonAverageStats.season != 0 && regularSeasonGames.count < 1 {
            selectedRegularValue = selectedValue
            selectedRegularPickerRow = selectedPickerRow
        }
        let regularGames = URL(string: "https://www.balldontlie.io/api/v1/stats?&per_page=100&page=&player_ids[]=" + "\(id!)" + "&seasons[]=" + selectedRegularValue)!

        let task = URLSession.shared.dataTask(with: regularGames) { [weak self] (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let dataArray = jsonResponse["data"] as? [[String: Any]] {
                        // The "data" key is present and contains an array of dictionaries

                        let decoder = JSONDecoder()
                        let jsonData = try JSONSerialization.data(withJSONObject: dataArray, options: [])
                        var games = try decoder.decode([Game].self, from: jsonData)
                        if games.count < 1 {
                            return
                        }
                        var sortedGames = games.sorted { $0.game.date.compare($1.game.date, options: .numeric) == .orderedAscending }
                        self?.regularSeasonGames.removeAll() // Clear the old data
                        for game in sortedGames {
                            // Check if the minutes value is not nil before converting to Int
                            if game.game.postseason == false {
                                self?.regularSeasonGames.append(game)
                            }
                        }
                        DispatchQueue.main.async {
                            self?.regularSeasonGamesTable.reloadData() // Reload the table with new data
                        }
                    } else {
                        print("Invalid JSON format: 'data' key not found or not of expected type")
                    }
                } else {
                    print("Invalid JSON format or response not a dictionary")
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        task.resume()
    }
    func getPlayoffGames() {
        if seasonAverageStats.season != 0 && postSeasonGames.count < 1 {
            selectedPlayoffValue = selectedValue
            selectedPlayoffPickerRow = selectedPickerRow
        }
        let playoffGames = URL(string: "https://www.balldontlie.io/api/v1/stats?&page=&per_page=100&postseason=true&player_ids[]=" + "\(id!)" + "&seasons[]=" + selectedPlayoffValue)!

        let task = URLSession.shared.dataTask(with: playoffGames) { [weak self] (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let dataArray = jsonResponse["data"] as? [[String: Any]] {
                        // The "data" key is present and contains an array of dictionaries

                        let decoder = JSONDecoder()
                        let jsonData = try JSONSerialization.data(withJSONObject: dataArray, options: [])
                        var games = try decoder.decode([Game].self, from: jsonData)
                        if games.count < 1 {
                            return
                        }
                        var sortedGames = games.sorted { $0.game.date.compare($1.game.date, options: .numeric) == .orderedAscending }
                        self?.postSeasonGames.removeAll() // Clear the old data
                        for game in sortedGames {
                            self?.postSeasonGames.append(game)
                        }
                        DispatchQueue.main.async {
                            self?.playoffGamesTable.reloadData() // Reload the table with new data
                        }
                    } else {
                        print("Invalid JSON format: 'data' key not found or not of expected type")
                    }
                } else {
                    print("Invalid JSON format or response not a dictionary")
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        task.resume()
    }
}

extension StatsVC: UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource { // Season Average Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 { // Season Average
            return 1
        } else if tableView.tag == 2 {
            return max(regularSeasonGames.count, 1)
        } else if tableView.tag == 3 {
            return max(postSeasonGames.count, 1)
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1 {
            let cell = seasonAvgTable.dequeueReusableCell(withIdentifier: "averageCell", for: indexPath) as! TableViewCell
            let text = "Season Average"
            let label = cell.viewWithTag(100) as! UILabel
            label.text = text
            label.preferredMaxLayoutWidth = label.intrinsicContentSize.width

            // Remove the old picker view from the cell's content view
            for subview in cell.contentView.subviews {
                if let pickerView = subview as? UIPickerView {
                    pickerView.removeFromSuperview()
                }
            }
            
            let pickerView = UIPickerView(frame: CGRect(x: 195, y: -20, width: 150, height: 100))
            pickerView.delegate = self
            pickerView.dataSource = self
            pickerView.tag = tableView.tag
            cell.contentView.addSubview(pickerView)

            // Set the picker's selected row to the previously selected value
            pickerView.selectRow(selectedPickerRow, inComponent: 0, animated: false)
            
            // Update the cell with the seasonAverageStats if available
            cell.seasonAverageStats = seasonAverageStats
            
            return cell
        } else if tableView.tag == 2 {
            let cell = regularSeasonGamesTable.dequeueReusableCell(withIdentifier: "regularCell", for: indexPath) as! GameViewCell
                    
            if indexPath.row == 0 {
                // Remove any existing UIPickerView
                for subview in cell.contentView.subviews {
                    if let pickerView = subview as? UIPickerView {
                        pickerView.removeFromSuperview()
                        break
                    }
                }
                let text = "Regular Season"
                let label = cell.viewWithTag(200) as! UILabel
                label.text = text
                label.preferredMaxLayoutWidth = label.intrinsicContentSize.width
                let pickerView = UIPickerView(frame: CGRect(x: 195, y: -20, width: 150, height: 100))
                pickerView.delegate = self
                pickerView.dataSource = self
                pickerView.tag = tableView.tag
                cell.contentView.addSubview(pickerView)

                // Set the picker's selected row to the previously selected value
                pickerView.selectRow(selectedRegularPickerRow, inComponent: 0, animated: false)
                if regularSeasonGames.count != 0 {
                    cell.game = regularSeasonGames[indexPath.row]
                }
            } else {
                for subview in cell.contentView.subviews {
                    if let pickerView = subview as? UIPickerView {
                        pickerView.removeFromSuperview()
                        break
                    }
                }

                // Cell configuration for other rows
                let text = "Game \(indexPath.row + 1)" // Replace this with the appropriate title for each row
                let label = cell.viewWithTag(200) as! UILabel
                label.text = text
                label.preferredMaxLayoutWidth = label.intrinsicContentSize.width
                cell.game = regularSeasonGames[indexPath.row]
            }
            return cell
        } else {
            let cell = playoffGamesTable.dequeueReusableCell(withIdentifier: "playoffCell", for: indexPath) as! GameViewCell
            
            if indexPath.row == 0 || postSeasonGames.count < 1 {
                // Remove any existing UIPickerView
                for subview in cell.contentView.subviews {
                    if let pickerView = subview as? UIPickerView {
                        pickerView.removeFromSuperview()
                        break
                    }
                }
                let text = "Playoff Games"
                let label = cell.viewWithTag(300) as! UILabel
                label.text = text
                label.preferredMaxLayoutWidth = label.intrinsicContentSize.width
                let pickerView = UIPickerView(frame: CGRect(x: 195, y: -20, width: 150, height: 100))
                pickerView.delegate = self
                pickerView.dataSource = self
                pickerView.tag = tableView.tag
                cell.contentView.addSubview(pickerView)

                // Set the picker's selected row to the previously selected value
                pickerView.selectRow(selectedPlayoffPickerRow, inComponent: 0, animated: false)
                if postSeasonGames.count != 0 {
                    cell.game = postSeasonGames[indexPath.row]
                }
            } else {
                for subview in cell.contentView.subviews {
                    if let pickerView = subview as? UIPickerView {
                        pickerView.removeFromSuperview()
                        break
                    }
                }

                // Cell configuration for other rows
                let text = "Game \(indexPath.row + 1)" // Replace this with the appropriate title for each row
                let label = cell.viewWithTag(300) as! UILabel
                label.text = text
                label.preferredMaxLayoutWidth = label.intrinsicContentSize.width
                cell.game = postSeasonGames[indexPath.row]
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2022 - 1945 // Update with the number of rows you want
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag != 0 {
            let title = "\(2022 - row)-\(2022 - 2000 - row + 1)" // Update with the titles for your rows
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 10) // Set the desired font size here
            ]
            return NSAttributedString(string: title, attributes: attributes).string
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            selectedValue = "\(2022 - row)"
            selectedPickerRow = row // Store the selected row
            getPlayerStats()
        } else if pickerView.tag == 2 {
            selectedRegularValue = "\(2022 - row)"
            selectedRegularPickerRow = row // Store the selected row
            getRegularSeasonGames()
            regularSeasonGamesTable.reloadData()
        } else if pickerView.tag == 3 {
            selectedPlayoffValue = "\(2022 - row)"
            selectedPlayoffPickerRow = row // Store the selected row
            getPlayoffGames()
            playoffGamesTable.reloadData()
        }
    }
}
