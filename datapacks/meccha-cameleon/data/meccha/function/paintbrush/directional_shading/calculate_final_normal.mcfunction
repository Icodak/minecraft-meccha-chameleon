# Convert double-precision coordinates to scaled scoreboard values
execute store result score $marker_x meccha.math run data get storage meccha.math marker_pos[0] 10000
execute store result score $marker_y meccha.math run data get storage meccha.math marker_pos[1] 10000
execute store result score $marker_z meccha.math run data get storage meccha.math marker_pos[2] 10000

execute store result score $entity_x meccha.math run data get storage meccha.math entity_pos[0] 10000
execute store result score $entity_y meccha.math run data get storage meccha.math entity_pos[1] 10000
execute store result score $entity_z meccha.math run data get storage meccha.math entity_pos[2] 10000

# Subtract positions to leave only the direction vector components
scoreboard players operation $marker_x meccha.math -= $entity_x meccha.math
scoreboard players operation $marker_y meccha.math -= $entity_y meccha.math
scoreboard players operation $marker_z meccha.math -= $entity_z meccha.math

# Write the final normalized floats into storage
execute store result storage meccha.math world_normal.x float 0.0001 run scoreboard players get $marker_x meccha.math
execute store result storage meccha.math world_normal.y float 0.0001 run scoreboard players get $marker_y meccha.math
execute store result storage meccha.math world_normal.z float 0.0001 run scoreboard players get $marker_z meccha.math

# Push the results straight to the user chat interface
tellraw @a [{"text": "Text Display Normal: [", "color": "green"}, {"storage": "meccha.math", "nbt": "world_normal.x", "interpret": false}, {"text": ", "}, {"storage": "meccha.math", "nbt": "world_normal.y", "interpret": false}, {"text": ", "}, {"storage": "meccha.math", "nbt": "world_normal.z", "interpret": false}, {"text": "]"}]