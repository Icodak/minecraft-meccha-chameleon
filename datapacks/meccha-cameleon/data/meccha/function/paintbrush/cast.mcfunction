# meccha:paintbrush/cast
# PILLAR 4.2 — purely-virtual raycast against the custom player rig. No
# Bookshelf block step: we intersect the mathematical planes of every rig cuboid
# directly, find the nearest face, localize to (face,u,v), and recolour that
# pixel with the player's own colour (meccha.color).
# Executed: at <player> anchored eyes.
function meccha:lib/raycast/capture_ray

# Fresh nearest-hit record.
data modify storage meccha:rt brush set value {found:0b}
function meccha:paintbrush/update_brush_type
scoreboard players set #BEST_T meccha.math 2000000000

# Visit every rig cuboid (markers carry their own geometry in `data`).
execute as @e[tag=meccha_cuboid,distance=..8] run function meccha:paintbrush/test_cuboid

execute if data storage meccha:rt {brush:{found:1b}} run function meccha:paintbrush/paint
execute unless data storage meccha:rt {brush:{found:1b}} run title @s actionbar {"text":"Brush missed the rig","color":"gray"}
