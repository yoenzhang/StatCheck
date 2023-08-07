//
//  HomeVC.swift
//  StatCheck
//
//  Created by Yoen Zhang on 2023-07-04.
//

import UIKit
import Foundation

class HomeVC: UIViewController {
    
    @IBOutlet var playerSearchBar: UISearchBar!
    @IBOutlet var playerTableView: UITableView!
    var filterPlayerNames = [String]()
    struct Player: Decodable {
        let id : Int
        let first_name : String
        let last_name : String
        var team: Team
    }
    struct Team: Decodable {
        let id : Int
        let full_name : String
        let abbreviation: String
    }
    var allPlayers: [Player] = []
    var playerNamesAndTeam: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        loadJson()
        self.filterPlayerNames = playerNamesAndTeam
    }

    func loadJson() {
        let url = Bundle.main.url(forResource: "players", withExtension: "json")!
            let data = try! Data(contentsOf: url)
        let playersInfo = try! JSONDecoder().decode([Player].self, from: data)
            for playerInfo in playersInfo {
                allPlayers.append(playerInfo)
                playerNamesAndTeam.append(playerInfo.first_name + " " + playerInfo.last_name + " - " +  playerInfo.team.abbreviation)
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToStatsVC" {
            let destVC = segue.destination as! StatsVC
            destVC.id = (sender as! Int)
        } else {
            // Handle the other case (if needed)
        }
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    func tableView(_ playerTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterPlayerNames.count
    }
    func tableView(_ playerTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = playerTableView.dequeueReusableCell(withIdentifier: "PlayerNameCell")
        cell?.textLabel?.text = filterPlayerNames[indexPath.row]
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let foundPlayer: Player = getPlayerId(playerName: filterPlayerNames[indexPath.row])
        performSegue(withIdentifier: "ToStatsVC", sender: foundPlayer.id)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            self.filterPlayerNames = playerNamesAndTeam.filter{ $0.lowercased().contains(searchText.lowercased()) }
            playerTableView.reloadData()
        } else {
            self.filterPlayerNames = playerNamesAndTeam
            playerTableView.reloadData()
        }
    }
    func getPlayerId(playerName: String) -> Player {
        let fullName = playerName.split(separator: " ", maxSplits: 1)
        let teamName = playerName.split(separator: "-")
        let playersSearch = allPlayers.firstIndex( where: {
            (fullName[0].contains($0.first_name) && fullName[1].contains($0.last_name) && teamName[1].contains($0.team.abbreviation))
        })
        return allPlayers[playersSearch!]
    }
}


