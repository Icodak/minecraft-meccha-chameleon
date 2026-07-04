# meccha:paintbrush/paint   (executed AS the painting player)
# Load this player's last sampled colour, then recolour the target(s)
# selected by the active brush — pixel, cross, face, or cube.
# Per-player colour/brush state keeps painters independent in multiplayer.
function meccha:lib/color/unpack
data modify storage meccha:rt brush.color set from storage meccha:rt sample.rgb

execute if data storage meccha:rt {brush:{type:"pixel"}} run function meccha:paintbrush/paint_pixel with storage meccha:rt brush
execute if data storage meccha:rt {brush:{type:"cross"}} run function meccha:paintbrush/paint_cross with storage meccha:rt brush
execute if data storage meccha:rt {brush:{type:"face"}} run function meccha:paintbrush/paint_face with storage meccha:rt brush
execute if data storage meccha:rt {brush:{type:"cube"}} run function meccha:paintbrush/paint_cube with storage meccha:rt brush

playsound minecraft:entity.painting.place player @s ~ ~ ~ 0.7 1.4