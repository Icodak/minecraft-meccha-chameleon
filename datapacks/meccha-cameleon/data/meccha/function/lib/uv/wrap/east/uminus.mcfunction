# meccha:lib/uv/wrap/east/uminus   (macro: $(v))   east -u → south, entry u=umax-1, v carried
data modify storage meccha:rt cross.face set value "south"
function meccha:lib/cuboid/get_face_bounds with storage meccha:rt cross
scoreboard players operation #wrap.u meccha.math = #face.umax meccha.math
scoreboard players remove #wrap.u meccha.math 1
execute store result storage meccha:rt cross.u int 1 run scoreboard players get #wrap.u meccha.math
$data modify storage meccha:rt cross.v set value $(v)
function meccha:paintbrush/paint_pixel with storage meccha:rt cross