# meccha:rig/follow_owner   (executed AS a bound player, at @s)
# Move this player's bound rig to the player, then re-apply its pose.
execute unless score @s meccha.rig matches 1.. run return 0
data modify storage meccha:rt fol set value {rid:0}
execute store result storage meccha:rt fol.rid int 1 run scoreboard players get @s meccha.rig
function meccha:rig/follow_do with storage meccha:rt fol
