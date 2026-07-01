# meccha:game/settings
# Show the current round settings + game phase.
tellraw @s [{"text":"\u2500\u2500 Round Settings \u2500\u2500","color":"gold","bold":true}]
tellraw @s [{"text":"phase: ","color":"gray"},{"nbt":"phase","storage":"meccha:game","color":"aqua"}]
tellraw @s [{"text":"hide_seconds: ","color":"gray"},{"nbt":"hide_seconds","storage":"meccha:settings","color":"yellow"}]
tellraw @s [{"text":"round_seconds: ","color":"gray"},{"nbt":"round_seconds","storage":"meccha:settings","color":"yellow"}]
tellraw @s [{"text":"freeze_hunters: ","color":"gray"},{"nbt":"freeze_hunters","storage":"meccha:settings","color":"yellow"}]
