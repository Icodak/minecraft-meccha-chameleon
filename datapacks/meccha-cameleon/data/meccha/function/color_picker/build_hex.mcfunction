# meccha:color_picker/build_hex   (macro: $(r) $(g) $(b) ints 0..255)
# Look up each channel byte and assemble "#RRGGBB".
$data modify storage meccha:rt rgb.rh set from storage meccha:consts int2hex."$(r)"
$data modify storage meccha:rt rgb.gh set from storage meccha:consts int2hex."$(g)"
$data modify storage meccha:rt rgb.bh set from storage meccha:consts int2hex."$(b)"
function meccha:color_picker/assemble_hex with storage meccha:rt rgb
