# meccha:paintbrush/paint   (executed AS the painting player)
# Load this player's last sampled colour, then recolour
# the single pixel entity addressed by its unique (cuboid, face, u, v) tags.
# Per-player colour keeps painters independent in multiplayer.
function meccha:lib/color/unpack
data modify storage meccha:rt brush.color set string storage meccha:rt last_sample 0 7
function meccha:paintbrush/paint_pixel with storage meccha:rt brush
playsound minecraft:entity.painting.place player @s ~ ~ ~ 0.7 1.4
