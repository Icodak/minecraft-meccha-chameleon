# meccha:lib/uv/wrap/bottom/uplus   (macro: $(v))    down +u → east, entry east.v=vmax-1, east.u = down.v (direct)
data modify storage meccha:rt cross.face set value "east"
function meccha:lib/cuboid/get_face_bounds with storage meccha:rt cross
scoreboard players operation #wrap.v meccha.math = #face.vmax meccha.math
scoreboard players remove #wrap.v meccha.math 1
execute store result storage meccha:rt cross.v int 1 run scoreboard players get #wrap.v meccha.math
$data modify storage meccha:rt cross.u set value $(v)
function meccha:paintbrush/paint_pixel with storage meccha:rt cross