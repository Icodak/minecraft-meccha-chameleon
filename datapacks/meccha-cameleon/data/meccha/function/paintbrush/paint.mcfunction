# meccha:paintbrush/paint   (executed AS the painting player)
# Load this player's stored colour, then recolour the target(s)
# selected by the active brush — pixel, cross, face, or cube.
# Per-player colour/brush state keeps painters independent in multiplayer.
function meccha:lib/uuid/store_current_uuid_as_string with entity @s
function meccha:lib/color/load_player_color with storage meccha:player

execute if entity @s[tag=paint_with_automatic_directional_shadow] run data modify storage meccha:rt brush.shadow set value 1
execute unless entity @s[tag=paint_with_automatic_directional_shadow] run data modify storage meccha:rt brush.shadow set value 0


execute if data storage meccha:rt {brush:{type:"pixel"}} run function meccha:paintbrush/paint_pixel with storage meccha:rt brush
execute if data storage meccha:rt {brush:{type:"cross"}} run function meccha:paintbrush/paint_cross with storage meccha:rt brush
execute if data storage meccha:rt {brush:{type:"face"}} run function meccha:paintbrush/paint_face with storage meccha:rt brush
execute if data storage meccha:rt {brush:{type:"cube"}} run function meccha:paintbrush/paint_cube with storage meccha:rt brush

playsound minecraft:entity.fish.swim player @s ~ ~ ~ 0.7 1.6