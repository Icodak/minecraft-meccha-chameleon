# meccha:lib/uv/wrap/bottom/vplus   (macro: $(u))    down +v → north, entry north.v=vmax-1, north.u = umax-1-down.u (inverted)
data modify storage meccha:rt cross.face set value "north"
function meccha:lib/cuboid/get_face_bounds with storage meccha:rt cross
scoreboard players operation #wrap.v meccha.math = #face.vmax meccha.math
scoreboard players remove #wrap.v meccha.math 1
scoreboard players operation #inv.max meccha.math = #face.umax meccha.math
$scoreboard players set #inv.val meccha.math $(u)
function meccha:lib/uv/invert
execute store result storage meccha:rt cross.v int 1 run scoreboard players get #wrap.v meccha.math
execute store result storage meccha:rt cross.u int 1 run scoreboard players get #inv.out meccha.math
function meccha:paintbrush/paint_pixel with storage meccha:rt cross