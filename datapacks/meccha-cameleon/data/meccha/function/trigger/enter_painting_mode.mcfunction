# meccha:trigger/enter_painting_mode  (advancement reward, runs as the player)
advancement revoke @s only meccha:enter_painting_mode
execute at @s anchored eyes run function meccha:items/painting_kit

tag @s add can_fly

function meccha:game/enter_painting_mode