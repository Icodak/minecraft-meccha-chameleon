# meccha:lib/color/load_player_color   (macro: $(uuid_key), executed AS the player)
# Load this player's chosen hex colour from meccha:players.color.<uuid-key>.
# Falls back to the shared last_sample colour when that player has not picked one yet.
$execute if data storage meccha:players color."$(uuid_key)" run data modify storage meccha:rt brush.color set from storage meccha:players color."$(uuid_key)"
$execute unless data storage meccha:players color."$(uuid_key)" run data modify storage meccha:rt brush.color set value "#000000"
