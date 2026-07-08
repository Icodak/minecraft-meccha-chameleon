$execute at @s rotated as @s run summon minecraft:marker ^$(x) ^$(y) ^$(z) {Tags: ["temp_normal"]}

# Pull the absolute positions into storage
data modify storage meccha.math marker_pos set from entity @e[tag=temp_normal,limit=1] Pos
data modify storage meccha.math entity_pos set from entity @s Pos

# Discard the calculation marker
kill @e[tag=temp_normal]

# Subtract the positions to extract the finalized vector direction
function meccha:paintbrush/directional_shading/calculate_final_normal

function meccha:paintbrush/directional_shading/calculate_final_normal