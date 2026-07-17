# fly:exit - leave flight mode and reset everything to defaults
tag @s remove fly.flying
effect clear @s minecraft:levitation
effect clear @s minecraft:slow_falling
attribute @s minecraft:gravity modifier remove fly:zero_gravity
scoreboard players set @s fly.tap 0
scoreboard players set @s fly.state 0

title @s actionbar [{"text":"Flight disabled","color":"gray"}]
