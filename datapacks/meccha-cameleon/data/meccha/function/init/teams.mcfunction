# meccha:init/teams
# A no-collision, hidden-nametag team for all rig pixel/overlay displays.
team add meccha_rig
team modify meccha_rig collisionRule never
team modify meccha_rig nametagVisibility never
# Player role teams (colour + friendly-fire control).
team add meccha_hunters
team modify meccha_hunters color red
team modify meccha_hunters prefix [{"text":"☠ ","color":"red"}]
team add meccha_hiders
team modify meccha_hiders color green
team modify meccha_hiders nametagVisibility hideForOtherTeams
team modify meccha_hiders collisionRule never
team modify meccha_hiders friendlyFire false
team modify meccha_hiders seeFriendlyInvisibles false