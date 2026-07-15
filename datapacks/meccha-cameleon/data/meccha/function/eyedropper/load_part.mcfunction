# meccha:eyedropper/load_part   (macro: $(model) from sel)
# Resolve one model -> {shape, textures}. Block entities / missing-parent
# models have no shape and contribute nothing (guarded below).
data modify storage meccha:rt part set value {}
$data modify storage meccha:rt part set from storage meccha:registry models."$(model)"
execute if data storage meccha:rt part.shape run function meccha:eyedropper/append_part_faces with storage meccha:rt part
