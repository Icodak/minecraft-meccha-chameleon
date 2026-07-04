# meccha:lib/uv/wrap/south/vplus   (macro: $(u))    south +v → down, entry v=0, down.u = south.u (direct)
data modify storage meccha:rt cross.face set value "bottom"
data modify storage meccha:rt cross.v set value 0
$data modify storage meccha:rt cross.u set value $(u)
function meccha:paintbrush/paint_pixel with storage meccha:rt cross