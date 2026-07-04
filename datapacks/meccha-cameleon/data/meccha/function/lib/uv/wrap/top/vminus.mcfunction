# meccha:lib/uv/wrap/top/vminus   (macro: $(u))    top -v → north, entry north.v=0, north.u = umax-1-top.u (inverted)
data modify storage meccha:rt cross.face set value "north"
function meccha:lib/cuboid/get_face_bounds with storage meccha:rt cross
scoreboard players operation #inv.max meccha.math = #face.umax meccha.math
$scoreboard players set #inv.val meccha.math $(u)
function meccha:lib/uv/invert
execute store result storage meccha:rt cross.u int 1 run scoreboard players get #inv.out meccha.math
data modify storage meccha:rt cross.v set value 0
function meccha:paintbrush/paint_pixel with storage meccha:rt cross