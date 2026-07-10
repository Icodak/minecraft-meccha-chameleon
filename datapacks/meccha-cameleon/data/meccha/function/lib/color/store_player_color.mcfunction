# meccha:lib/color/store_player_color   (macro: $(uuid_key) $(color), executed AS the player)
# Store this player's chosen hex color under meccha:players.color.<uuid-key>.
$data modify storage meccha:players color."$(uuid_key)" set value "$(color)"
