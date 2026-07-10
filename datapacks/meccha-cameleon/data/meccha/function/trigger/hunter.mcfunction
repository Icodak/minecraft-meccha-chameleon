# meccha:trigger/hunter  (advancement reward, runs as the player)
advancement revoke @s only meccha:hunter_use
# say hunter
execute at @s anchored eyes run function meccha:hunter/fire

function meccha:items/hunter_cooldown_kit
tag @s add needs_hunter_kit_after_cooldown
schedule function meccha:items/scheduled_hunter_kit_after_cooldown 3s