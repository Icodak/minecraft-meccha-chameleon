# fly:state_hover - Jump released (and not sneaking): hover with gravity forced to 0
effect clear @s minecraft:levitation
effect clear @s minecraft:slow_falling
# Remove then re-add so the modifier is always present exactly once.
# add_multiplied_total by -1 => gravity * (1 + (-1)) = 0
attribute @s minecraft:gravity modifier remove fly:zero_gravity
attribute @s minecraft:gravity modifier add fly:zero_gravity -1 add_multiplied_total
scoreboard players set @s fly.state 0
