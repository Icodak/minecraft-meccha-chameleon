# meccha:eyedropper/resolve_state   (macro: called `with storage meccha:rt block`)
# PILLAR 4.1 Step 2 - fetch this block's state record, then bake the geometry
# of EVERY applicable model into ONE combined face list (`faces`):
#   * variants  (match="first"): the first matching variant contributes.
#   * multipart (match="all")  : every matching part contributes (fences,
#     walls, redstone, fire, ...), exactly like vanilla stacks its parts.
# The secondary raycast then runs a single nearest-hit pass over that union.
$data modify storage meccha:rt state set from storage meccha:registry states."$(type)"
data modify storage meccha:rt cases set from storage meccha:rt state.cases
data modify storage meccha:rt mmode set from storage meccha:rt state.match
data modify storage meccha:rt faces set value []
function meccha:eyedropper/match_case
