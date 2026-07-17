# fly:state_slowfall - Sneak held: descend slowly using Slow Falling, gravity default
attribute @s minecraft:gravity modifier remove fly:zero_gravity
attribute @s minecraft:gravity modifier add fly:zero_gravity -0.5 add_multiplied_total
effect clear @s minecraft:levitation
scoreboard players set @s fly.state 2
