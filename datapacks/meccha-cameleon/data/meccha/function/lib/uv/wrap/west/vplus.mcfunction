# meccha:lib/uv/wrap/west/vplus   (macro: $(u))    west +v → down, entry down.u=0, down.v = vmax-1-west.u (inverted)
data modify storage meccha:rt cross.face set value "bottom"
function meccha:lib/cuboid/get_face_bounds with storage meccha:rt cross
scoreboard players operation #inv.max meccha.math = #face.vmax meccha.math
$scoreboard players set #inv.val meccha.math $(u)
function meccha:lib/uv/invert
execute store result storage meccha:rt cross.v int 1 run scoreboard players get #inv.out meccha.math
data modify storage meccha:rt cross.u set value 0
function meccha:paintbrush/paint_pixel with storage meccha:rt cross