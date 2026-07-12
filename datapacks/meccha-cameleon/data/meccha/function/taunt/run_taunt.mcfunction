execute unless score @s meccha.rig matches 1.. run return run title @s actionbar {"text":"No rig bound - use /function meccha:rig/spawn_for","color":"gray"}
execute store result storage meccha:taunt rid int 1 run scoreboard players get @s meccha.rig

function meccha:taunt/play_taunt with storage meccha:taunt