# meccha:role/make_hunter   (executed AS the target player)
# Assign the Hunter role: tag, team, fresh kit.
tag @s remove meccha_hider
tag @s add meccha_hunter
team join meccha_hunters @s
function meccha:role/clear_items
# A hunter carries no rig \u2014 release one they may have had as a hider.
function meccha:rig/unbind
function meccha:give/hunter_kit
title @s title [{"text":"HUNTER","color":"red","bold":true}]
title @s subtitle [{"text":"Hunt down every hider.","color":"gray"}]
playsound minecraft:entity.wither.spawn player @s ~ ~ ~ 0.5 1.6
