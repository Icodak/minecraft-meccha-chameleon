# meccha:lib/uv/wrap/north/vplus   (macro: $(u))   north +v → down, entry down.v=vmax-1, down.u = umax-1-north.u (inverted)
data modify storage meccha:rt cross.face set value "bottom"
function meccha:lib/cuboid/get_face_bounds with storage meccha:rt cross
scoreboard players operation #wrap.v meccha.math = #face.vmax meccha.math
scoreboard players remove #wrap.v meccha.math 1
scoreboard players operation #inv.max meccha.math = #face.umax meccha.math
$scoreboard players set #inv.val meccha.math $(u)
function meccha:lib/uv/invert
execute store result storage meccha:rt cross.v int 1 run scoreboard players get #wrap.v meccha.math
execute store result storage meccha:rt cross.u int 1 run scoreboard players get #inv.out meccha.math
function meccha:paintbrush/paint_pixel with storage meccha:rt cross