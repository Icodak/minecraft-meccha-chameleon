# meccha:lib/uv/wrap/top/vplus   (macro: $(u))     top +v → south, entry south.v=0, south.u = top.u (direct)
data modify storage meccha:rt cross.face set value "south"
data modify storage meccha:rt cross.v set value 0
$data modify storage meccha:rt cross.u set value $(u)
function meccha:paintbrush/paint_pixel with storage meccha:rt cross