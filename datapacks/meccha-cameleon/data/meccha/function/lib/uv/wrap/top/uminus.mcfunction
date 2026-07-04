# meccha:lib/uv/wrap/top/uminus   (macro: $(v))    top -u → west, entry west.v=0, west.u = top.v (direct)
data modify storage meccha:rt cross.face set value "west"
data modify storage meccha:rt cross.v set value 0
$data modify storage meccha:rt cross.u set value $(v)
function meccha:paintbrush/paint_pixel with storage meccha:rt cross