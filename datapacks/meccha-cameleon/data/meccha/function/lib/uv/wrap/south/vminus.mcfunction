# meccha:lib/uv/wrap/south/vminus   (macro: $(u))   south -v → top, entry v=vmax(top)-1, top.u = south.u (direct)
data modify storage meccha:rt cross.face set value "top"
function meccha:lib/cuboid/get_face_bounds with storage meccha:rt cross
scoreboard players operation #wrap.v meccha.math = #face.vmax meccha.math
scoreboard players remove #wrap.v meccha.math 1
execute store result storage meccha:rt cross.v int 1 run scoreboard players get #wrap.v meccha.math
$data modify storage meccha:rt cross.u set value $(u)
function meccha:paintbrush/paint_pixel with storage meccha:rt cross