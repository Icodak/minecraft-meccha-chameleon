# meccha:eyedropper/finalize   (executed AS the sampling player)
# Store the sampled colour as THIS player's brush colour (meccha.color, packed
# 0xRRGGBB) so painters stay independent in multiplayer, then show feedback.
# say finalize
data modify storage meccha:rt col.hex set from storage meccha:rt sample.color
data modify storage meccha:rt col.rr set string storage meccha:rt col.hex 1 3
data modify storage meccha:rt col.gg set string storage meccha:rt col.hex 3 5
data modify storage meccha:rt col.bb set string storage meccha:rt col.hex 5 7
data modify storage meccha:rt col.aa set string storage meccha:rt col.hex 7 9
function meccha:lib/color/lookup with storage meccha:rt col
function meccha:lib/color/pack

# Display: strip alpha for a 7-char "#RRGGBB" swatch, keep last_sample for dev/info.
data modify storage meccha:rt last_sample set from storage meccha:rt sample.color
data modify storage meccha:rt sample.rgb set string storage meccha:rt sample.color 0 7
function meccha:eyedropper/feedback with storage meccha:rt sample
