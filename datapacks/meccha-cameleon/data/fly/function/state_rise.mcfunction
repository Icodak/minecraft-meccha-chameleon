# fly:state_rise - Jump held: rise using Levitation, gravity back to default
attribute @s minecraft:gravity modifier remove fly:zero_gravity
effect clear @s minecraft:slow_falling
effect give @s minecraft:levitation infinite 5 true
scoreboard players set @s fly.state 1
