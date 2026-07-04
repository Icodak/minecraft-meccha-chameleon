# meccha:paintbrush/update_brush_type   (executed AS the player)
# Sync this player's scoreboard brush selection into meccha:rt brush.type
# so paint_pixel/paint_cross/paint_face/paint_cube dispatch correctly.
# Encoding: 0=pixel  1=cross  2=face  3=cube
# Requires objective: scoreboard objectives add meccha.brush_type dummy

execute if score @s meccha.brush_type matches 0 run data modify storage meccha:rt brush.type set value "pixel"
execute if score @s meccha.brush_type matches 1 run data modify storage meccha:rt brush.type set value "cross"
execute if score @s meccha.brush_type matches 2 run data modify storage meccha:rt brush.type set value "face"
execute if score @s meccha.brush_type matches 3 run data modify storage meccha:rt brush.type set value "cube"

# fallback: default to pixel if the player has no score set yet
execute unless score @s meccha.brush_type matches 0..3 run data modify storage meccha:rt brush.type set value "pixel"