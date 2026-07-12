# meccha:trigger/directional_shadows  (advancement reward, runs as the player)
advancement revoke @s only meccha:pose_cycle_use
recipe take @s meccha:pose_cycle

function meccha:role/pose_used
execute if score @s meccha.hider_state = #RUNNING meccha.hider_state run function meccha:items/running_kit
execute if score @s meccha.hider_state = #PAINTING meccha.hider_state run function meccha:items/painting_kit

