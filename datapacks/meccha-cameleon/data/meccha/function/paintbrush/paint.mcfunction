# meccha:paintbrush/paint   (executed AS the painting player)
# Load this player's own colour (meccha.color) as an opaque ARGB, then recolour
# the single pixel entity addressed by its unique (cuboid, face, u, v) tags.
# Per-player colour keeps painters independent in multiplayer.
function meccha:lib/color/unpack
function meccha:paintbrush/paint_pixel with storage meccha:rt brush
playsound minecraft:entity.painting.place player @s ~ ~ ~ 0.7 1.4
