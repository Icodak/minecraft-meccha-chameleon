# meccha:lib/uv/wrap/east/vplus   (macro: $(u))    east +v → down, entry down.u=umax-1, down.v = east.u (direct)
data modify storage meccha:rt cross.face set value "bottom"
function meccha:lib/cuboid/get_face_bounds with storage meccha:rt cross
scoreboard players operation #wrap.u meccha.math = #face.umax meccha.math
scoreboard players remove #wrap.u meccha.math 1
execute store result storage meccha:rt cross.u int 1 run scoreboard players get #wrap.u meccha.math
$data modify storage meccha:rt cross.v set value $(u)
function meccha:paintbrush/paint_pixel with storage meccha:rt cross