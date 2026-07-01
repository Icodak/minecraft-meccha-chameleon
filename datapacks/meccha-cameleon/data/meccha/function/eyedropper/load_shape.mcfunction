# meccha:eyedropper/load_shape   (macro: called `with storage meccha:rt sample`)
# Resolve the chosen model -> {shape, textures}, then pull the flat face list.
# Reset mdl/faces first so a model with NO geometry (e.g. a missing-parent
# stairs corner) can't leave STALE faces from a previous cast to be reprocessed.
$say load shape $(model)
data modify storage meccha:rt mdl set value {}
data modify storage meccha:rt faces set value []
data modify storage meccha:rt sample.textures set value {}
$data modify storage meccha:rt mdl set from storage meccha:registry models."$(model)"
data modify storage meccha:rt sample.textures set from storage meccha:rt mdl.textures
# Only pull faces when the model actually resolved to a shape (guards the macro
# against a missing `shape` key, which would otherwise raise a macro error).
execute if data storage meccha:rt mdl.shape run function meccha:eyedropper/load_faces with storage meccha:rt mdl
