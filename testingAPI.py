from nba_api.stats.static import players

from nba_api.stats.endpoints import playercareerstats

career = playercareerstats.PlayerCareerStats(player_id='203076')
print(career.get_data_frames()[0])





#for i in range(0, 100):
#    print(allPlayer[i])