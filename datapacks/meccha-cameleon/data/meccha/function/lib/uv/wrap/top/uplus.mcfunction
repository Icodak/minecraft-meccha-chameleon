# meccha:lib/uv/wrap/top/uplus   (macro: $(v))     top +u → east, entry east.v=0, east.u = umax-1-top.v (inverted)
data modify storage meccha:rt cross.face set value "east"
function meccha:lib/cuboid/get_face_bounds with storage meccha:rt cross
scoreboard players operation #inv.max meccha.math = #face.umax meccha.math
$scoreboard players set #inv.val meccha.math $(v)
function meccha:lib/uv/invert
execute store result storage meccha:rt cross.u int 1 run scoreboard players get #inv.out meccha.math
data modify storage meccha:rt cross.v set value 0
function meccha:paintbrush/paint_pixel with storage meccha:rt cross