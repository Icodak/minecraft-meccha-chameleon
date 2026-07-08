# meccha:rig/follow_owner   (executed AS a bound player, at @s)
# Move this player's bound rig to the player, then re-apply its pose.
execute unless score @s meccha.rig matches 1.. run return 0
data modify storage meccha:rt fol set value {rid:0}
execute store result storage meccha:rt fol.rid int 1 run scoreboard players get @s meccha.rig

execute store result score @s meccha.yaw run data get entity @s Rotation[0] 1
data modify storage meccha:rt fol.direction set value "north"
execute if score @s meccha.yaw matches -45..44 run data modify storage meccha:rt fol.direction set value "south"
execute if score @s meccha.yaw matches 45..134 run data modify storage meccha:rt fol.direction set value "west"
execute if score @s meccha.yaw matches -134..-46 run data modify storage meccha:rt fol.direction set value "east"


function meccha:rig/follow_do with storage meccha:rt fol
