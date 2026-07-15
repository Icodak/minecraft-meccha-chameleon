# meccha:eyedropper/bake_tex   (macro: $(var) from marg)
# Resolve "#var" -> final texture key via the part's flattened texture map.
# A var missing from the map leaves bface.tex as "" (reset by the caller), so
# the face is treated as untextured and skipped by record_best.
$data modify storage meccha:rt bface.tex set from storage meccha:rt parttex.$(var)
