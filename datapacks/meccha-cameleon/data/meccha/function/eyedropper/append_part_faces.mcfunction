# meccha:eyedropper/append_part_faces   (macro: $(shape) from part)
# Pull this part's texture-agnostic face list and its model texture map, then
# bake each face (with its final texture key) onto the combined `faces` list.
data modify storage meccha:rt partfaces set value []
$data modify storage meccha:rt partfaces set from storage meccha:registry shapes."$(shape)".faces
data modify storage meccha:rt parttex set from storage meccha:rt part.textures
function meccha:eyedropper/bake_faces
