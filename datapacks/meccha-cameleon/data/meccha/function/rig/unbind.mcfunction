# meccha:rig/unbind   (executed AS a player)
# Release this player's bound rig: despawn it and clear the binding.
execute if score @s meccha.rig matches 1.. run function meccha:rig/unbind_do
tag @s remove meccha_bound
scoreboard players reset @s meccha.rig
