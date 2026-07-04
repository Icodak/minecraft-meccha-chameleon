# meccha:lib/uv/wrap/north/uplus   (macro: $(v))   north +u → west, entry u=0, v carried
data modify storage meccha:rt cross.face set value "west"
data modify storage meccha:rt cross.u set value 0
$data modify storage meccha:rt cross.v set value $(v)
function meccha:paintbrush/paint_pixel with storage meccha:rt cross