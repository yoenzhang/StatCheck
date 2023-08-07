from nba_api.stats.endpoints import leaguegamelog
from nba_api.stats.endpoints import boxscoreplayertrackv2
from nba_api.stats.endpoints import boxscoretraditionalv2
from nba_api.stats.endpoints import boxscoreadvancedv2

regularSeasonGames = leaguegamelog.LeagueGameLog(season_type_all_star='Regular Season').get_data_frames()[0]
recentRegularSeasonGames = regularSeasonGames.tail(30)['GAME_ID']
#print(regularSeasonGames)
#print('Number of games fetched: {}'.format(len(regularSeason)))
playoffGames = leaguegamelog.LeagueGameLog(season_type_all_star='Playoffs').get_data_frames()[0]
recentPlayoffGames = playoffGames.tail(30)['GAME_ID']
#print(playoffGames)



def normalBoxScoreByGame(gameId):
    print(gameId)
    boxScore = boxscoretraditionalv2.BoxScoreTraditionalV2(game_id=gameId).get_data_frames()[0] #regular box score
    #boxScore = boxscoreadvancedv2.BoxScoreAdvancedV2(game_id=gameId).get_data_frames()[0] ##advanced metrics
    #playersFromGame = gamerotation.GameRotation(game_id=gameId).get_data_frames()[0]
    print(boxScore)
    
def advancedBoxScoreByGame(gameId):
    boxScore = boxscoreadvancedv2.BoxScoreAdvancedV2(game_id=gameId).get_data_frames()[0] ##advanced metrics
    print(boxScore)

def playerSpecificBoxScoreByGame(gameId):
    boxScore = boxscoreplayertrackv2.BoxScorePlayerTrackV2(game_id=gameId).get_data_frames()[0] #player specific
    print(boxScore)
    
for game in recentRegularSeasonGames:
    normalBoxScoreByGame(game)
    
normalBoxScoreByGame("0022201222")
