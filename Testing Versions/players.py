from nba_api.stats.endpoints import playercareerstats
from nba_api.stats.static import players
from nba_api.stats.endpoints import playergamelog
import requests
import json

nba_players = players.get_players()
print('Number of players fetched: {}'.format(len(nba_players)))

#searchPlayer = input("What player would you like to search for? ")

#for i in range(10):
    #print(nba_players[i]['id'])
    #print(temp['id'])

def getId(playerFullName): 
    for i in range(len(nba_players)):
        if nba_players[i]['full_name'].lower() == playerFullName.lower():
            return nba_players[i]['id']
            
def getStats(playerId, type):
    for i in range(len(nba_players)):
        if nba_players[i]['id'] == playerId:
            career = playercareerstats.PlayerCareerStats(player_id=str(playerId))
            print(career.get_data_frames()[0])
            #0 stats/season
            #1 totals
            #2 playoff/season stats
            #3 playoff totals
            #4 all star/season stats
            #5 all star totals
            
def getPlayerGameLogs(playerId, season) :
    for i in range(len(nba_players)):
        if nba_players[i]['id'] == playerId:
            playerGameLog = playergamelog.PlayerGameLog(player_id = str(playerId), season=season)
            print(playerGameLog.get_data_frames()[0])
            
#getId(searchPlayer)
#getStats(getId(searchPlayer), 1)
#getPlayerGameLogs(getId(searchPlayer), '2022-23')
with open("players.json", "w") as outfile:
    for i in range(1, 53):
        url = "https://www.balldontlie.io/api/v1/players?per_page=100&page="
        url += str(i)
        response = requests.get(url)
        output = response.json()["data"]
        outfile.write(json.dumps(output, indent=4))