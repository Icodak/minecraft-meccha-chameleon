# meccha:lib/uv/wrap/west/vminus   (macro: $(u))   west -v → top, entry top.u=0, top.v = west.u (direct)
data modify storage meccha:rt cross.face set value "top"
data modify storage meccha:rt cross.u set value 0
$data modify storage meccha:rt cross.v set value $(u)
function meccha:paintbrush/paint_pixel with storage meccha:rt cross