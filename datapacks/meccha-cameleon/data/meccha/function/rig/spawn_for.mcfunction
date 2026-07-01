# meccha:rig/spawn_for   (executed AS a player)
# Spawn a fresh rig at the player and BIND it to them: the player's meccha.rig
# score holds the rig id, they get the meccha_bound tag (so tick follows it),
# and the rig root is tagged as owned + follows the player.
execute at @s run function meccha:rig/init
# rig/init left the new rid in meccha:rt newrig.rid
execute store result score @s meccha.rig run data get storage meccha:rt newrig.rid
tag @s add meccha_bound
function meccha:rig/bind_owner with storage meccha:rt newrig
tellraw @s [{"text":"[Meccha] ","color":"green"},{"text":"rig bound - it now follows you (right-click the Pose Switcher to change stance).","color":"gray"}]
