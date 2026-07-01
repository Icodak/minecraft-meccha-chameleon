# meccha:eyedropper/fetch_pixel   (macro: $(texkey), $(index))
# Pull one "#RRGGBBAA" texel out of the texture's row-major px array.
$data modify storage meccha:rt pick.color set from storage meccha:registry textures."$(texkey)".px[$(index)]
