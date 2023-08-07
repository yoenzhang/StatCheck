from nba_api.stats.static import teams
from nba_api.stats.endpoints import leaguegamefinder

allTeams = teams.get_teams()

teamIds = []
for team in allTeams:
    teamIds.append(team['full_name'])
    
print(teamIds)

searchTeam = input("What team are you looking for? ")

if "hawks" in searchTeam.lower():
    team_id = teamIds[0]
elif "celtics" in searchTeam.lower():
    team_id = teamIds[0]
elif "nets" in searchTeam.lower():
    nets = [team for team in allTeams if team['abbreviation'] == 'BKN'][0]
    team_id = nets['id']
elif "hornets" in searchTeam.lower():
    hornets = [team for team in allTeams if team['abbreviation'] == 'CHA'][0]
    team_id = hornets['id']
elif "bulls" in searchTeam.lower():
    bulls = [team for team in allTeams if team['abbreviation'] == 'CHI'][0]
    team_id = bulls['id']
elif "cavs" in searchTeam.lower():
    cavs = [team for team in allTeams if team['abbreviation'] == 'CLE'][0]
    team_id = cavs['id']
elif "mavs" in searchTeam.lower():
    mavs = [team for team in allTeams if team['abbreviation'] == 'DAL'][0]
    team_id = mavs['id']
elif "nuggets" in searchTeam.lower():
    nuggets = [team for team in allTeams if team['abbreviation'] == 'DEN'][0]
    team_id = nuggets['id']
elif "pistons" in searchTeam.lower():
    pistons = [team for team in allTeams if team['abbreviation'] == 'DET'][0]
    team_id = pistons['id']
elif "warriors" in searchTeam.lower():
    warriors = [team for team in allTeams if team['abbreviation'] == 'GSW'][0]
    team_id = warriors['id']
elif "rockets" in searchTeam.lower():
    rockets = [team for team in allTeams if team['abbreviation'] == 'HOU'][0]
    team_id = rockets['id']
elif "pacers" in searchTeam.lower():
    pacers = [team for team in allTeams if team['abbreviation'] == 'IND'][0]
    team_id = pacers['id']
elif "clippers" in searchTeam.lower():
    clippers = [team for team in allTeams if team['abbreviation'] == 'LAC'][0]
    team_id = clippers['id']
elif "lakers" in searchTeam.lower():
    lakers = [team for team in allTeams if team['abbreviation'] == 'LAL'][0]
    team_id = lakers['id']
elif "grizzlies" in searchTeam.lower():
    grizzlies = [team for team in allTeams if team['abbreviation'] == 'MEM'][0]
    team_id = grizzlies['id']
elif "heat" in searchTeam.lower():
    heat = [team for team in allTeams if team['abbreviation'] == 'MIA'][0]
    team_id = heat['id']
elif "bucks" in searchTeam.lower():
    bucks = [team for team in allTeams if team['abbreviation'] == 'MIL'][0]
    team_id = bucks['id']
elif "timberwolves" in searchTeam.lower():
    timberwolves = [team for team in allTeams if team['abbreviation'] == 'MIN'][0]
    team_id = timberwolves['id']
elif "pelicans" in searchTeam.lower():
    pelicans = [team for team in allTeams if team['abbreviation'] == 'NOP'][0]
    team_id = pelicans['id']
elif "knicks" in searchTeam.lower():
    knicks = [team for team in allTeams if team['abbreviation'] == 'NYK'][0]
    team_id = knicks['id'] 
elif "thunder" in searchTeam.lower():
    thunder = [team for team in allTeams if team['abbreviation'] == 'OKC'][0]
    team_id = thunder['id']
elif "magic" in searchTeam.lower():
    magic = [team for team in allTeams if team['abbreviation'] == 'ORL'][0]
    team_id = magic['id']
elif "seventySixers" in searchTeam.lower():
    seventySixers = [team for team in allTeams if team['abbreviation'] == 'PHI'][0]
    team_id = seventySixers['id'] 
elif "suns" in searchTeam.lower():
    suns = [team for team in allTeams if team['abbreviation'] == 'PHX'][0]
    team_id = suns['id']
elif "trailblazers" in searchTeam.lower():
    trailblazers = [team for team in allTeams if team['abbreviation'] == 'POR'][0]
    team_id = trailblazers['id']
elif "kings" in searchTeam.lower():
    kings = [team for team in allTeams if team['abbreviation'] == 'SAC'][0]
    team_id = kings['id'] 
elif "spurs" in searchTeam.lower():
    spurs = [team for team in allTeams if team['abbreviation'] == 'SAS'][0]
    team_id = spurs['id']
elif "raptors" in searchTeam.lower():
    raptors = [team for team in allTeams if team['abbreviation'] == 'TOR'][0]
    team_id = raptors['id']
elif "jazz" in searchTeam.lower():
    jazz = [team for team in allTeams if team['abbreviation'] == 'UTA'][0]
    team_id = jazz['id'] 
elif "wizards" in searchTeam.lower():
    wizards = [team for team in allTeams if team['abbreviation'] == 'WAS'][0]
    team_id = wizards['id']

# Query for games where the Celtics were playing

def searchTeamGames(teamId):
    gamefinder = leaguegamefinder.LeagueGameFinder(team_id_nullable=teamId)
    # The first DataFrame of those returned is what we want.
    games = gamefinder.get_data_frames()[0]
    print(games.head(10))
    
searchTeamGames(team_id)