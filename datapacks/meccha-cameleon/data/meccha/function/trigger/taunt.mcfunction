# meccha:trigger/paintbrush_settings  (advancement reward, runs as the player)
advancement revoke @s only meccha:taunt_use
recipe take @s meccha:taunt

function meccha:taunt/run_taunt
execute if score @s meccha.hider_state = #RUNNING meccha.hider_state run function meccha:items/running_kit
execute if score @s meccha.hider_state = #PAINTING meccha.hider_state run function meccha:items/painting_kit