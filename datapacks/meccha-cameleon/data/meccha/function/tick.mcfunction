# meccha:tick
# Per-tick driver. Kept lean; heavy work is event-driven (advancements).
# Pillar 6: re-evaluate directional shading for rigs flagged dirty.
execute as @e[type=marker,tag=meccha_cuboid,tag=pose_dirty] run function meccha:shading/refresh_cuboid

# Pillar 7: nothing polled here - hunter hits are advancement-triggered.

# Gameplay: pose-switch item (discrete right-click) + round countdown.
execute as @a[scores={meccha.use_pose=1..}] at @s run function meccha:role/pose_used
function meccha:game/tick
function meccha:dialog/tick

# Ensure every player has a default brush colour (white) exactly once.
execute as @a unless score @s meccha.color matches 0.. run scoreboard players set @s meccha.color 16777215

# Bound rigs follow their owner (per-rig).
function meccha:rig/follow
