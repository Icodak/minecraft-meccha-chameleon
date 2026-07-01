# meccha:eyedropper/resolve_state   (macro: called `with storage meccha:rt block`)
# PILLAR 4.1 Step 2a \u2014 fetch this block's state record and start matching.
# `type` = full block id (e.g. "minecraft:oak_stairs") from Bookshelf get_block.
$data modify storage meccha:rt state set from storage meccha:registry states."$(type)"
data modify storage meccha:rt cases set from storage meccha:rt state.cases
function meccha:eyedropper/match_case
