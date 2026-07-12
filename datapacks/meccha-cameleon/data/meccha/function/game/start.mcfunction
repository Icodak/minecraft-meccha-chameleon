# meccha:game/start
# Begin a round: enter the HIDING phase. Hunters are blinded (vision hidden)
# and optionally frozen for settings.hide_seconds while hiders scatter.
# Requires at least one hunter and one hider.
execute unless entity @a[tag=meccha_hunter,limit=1] run return run tellraw @s [{"text":"[Meccha] ","color":"red"},{"text":"No hunter assigned.","color":"gray"}]
execute unless entity @a[tag=meccha_hider,limit=1] run return run tellraw @s [{"text":"[Meccha] ","color":"red"},{"text":"No hider assigned.","color":"gray"}]

function meccha:items/cancel_scheduled

function meccha:highlight_rig/stop_highlight_blink
function meccha:reset_rig

dialog clear @a
data modify storage meccha:game phase set value "hiding"
# timer (ticks) = hide_seconds * 20
execute store result score #HS meccha.sys run data get storage meccha:settings hide_seconds 1
scoreboard players set #C20 meccha.sys 20
scoreboard players operation #HS meccha.sys *= #C20 meccha.sys
execute store result storage meccha:game timer int 1 run scoreboard players get #HS meccha.sys

# Hide the hunters' vision for the whole hide window.
function meccha:game/blind_hunters with storage meccha:settings

# make hunter runs when the round truly starts to avoid early kills
execute as @a[tag=meccha_hider] run function meccha:role/make_hider

title @a times 0 2s 1s
title @a title [{"text":"Hide!","color":"green","bold":true}]
title @a[tag=meccha_hunter] title [{"text":"Blinded","color":"dark_red","bold":true}]
playsound minecraft:block.note_block.pling master @a ~ ~ ~ 1 1.5
tellraw @a [{"text":"[Meccha] ","color":"green"},{"text":"Round started - hide!","color":"gray"}]

function meccha:game/tp_to_selected_start_location with storage meccha:game selected_location
