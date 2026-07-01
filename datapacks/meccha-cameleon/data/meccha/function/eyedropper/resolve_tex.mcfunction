# meccha:eyedropper/resolve_tex   (macro: $(var) -> final texture key)
# Model textures are pre-flattened by the parser, so this is a single hop.
# $say resolve texture $(var)
$data modify storage meccha:rt pick.texkey set from storage meccha:rt sample.textures.$(var)
